import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static targets = ["cardList", "column"]

  connect() {
    this.cardListTargets.forEach(list => {
      Sortable.create(list, {
        group: "kanban",
        animation: 150,
        ghostClass: "opacity-30",
        dragClass: "shadow-lg",
        onEnd: this.onEnd.bind(this)
      })
    })
  }

  onEnd(event) {
    const card = event.item
    const applicantId = card.dataset.applicantId
    const newStatus = event.to.closest("[data-status]").dataset.status
    const oldStatus = event.from.closest("[data-status]").dataset.status

    if (newStatus !== oldStatus) {
      this.updateCounts(oldStatus, newStatus)
      this.persistMove(applicantId, newStatus)
    }
  }

  updateCounts(oldStatus, newStatus) {
    this.columnTargets.forEach(column => {
      const status = column.dataset.status
      const countEl = column.querySelector("[data-count]")
      if (!countEl) return

      const current = parseInt(countEl.textContent, 10)
      if (status === oldStatus) countEl.textContent = current - 1
      if (status === newStatus) countEl.textContent = current + 1
    })
  }

  persistMove(applicantId, newStatus) {
    const token = document.querySelector('meta[name="csrf-token"]').content

    fetch(`/applicants/${applicantId}/move`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "X-CSRF-Token": token
      },
      body: `status=${newStatus}`
    })
  }
}
