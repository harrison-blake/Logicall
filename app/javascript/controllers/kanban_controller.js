import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card"]

  dragstart(event) {
    event.dataTransfer.setData("applicant-id", event.target.dataset.applicantId)
    event.dataTransfer.effectAllowed = "move"
    event.target.classList.add("opacity-50")
  }

  dragend(event) {
    event.target.classList.remove("opacity-50")
  }

  dragover(event) {
    event.preventDefault()
    event.dataTransfer.dropEffect = "move"
    event.currentTarget.classList.add("bg-blue-50", "dark:bg-blue-900/20")
  }

  dragleave(event) {
    event.currentTarget.classList.remove("bg-blue-50", "dark:bg-blue-900/20")
  }

  drop(event) {
    event.preventDefault()
    event.currentTarget.classList.remove("bg-blue-50", "dark:bg-blue-900/20")

    const applicantId = event.dataTransfer.getData("applicant-id")
    const newStatus = event.currentTarget.dataset.status
    const token = document.querySelector('meta[name="csrf-token"]').content

    fetch(`/applicants/${applicantId}/move`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "X-CSRF-Token": token
      },
      body: `status=${newStatus}`
    }).then(response => {
      if (response.ok) {
        const card = document.querySelector(`[data-applicant-id="${applicantId}"]`)
        const dropzone = event.currentTarget.querySelector("[data-kanban-target='cardList']")
        dropzone.appendChild(card)
      }
    })
  }
}
