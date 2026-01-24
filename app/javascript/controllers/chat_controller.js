import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "messages"]

  submit(event) {
    const prompt = this.inputTarget.value.trim()
    if (!prompt) {
      event.preventDefault()
      return
    }

    // Add user message immediately
    this.messagesTarget.insertAdjacentHTML("beforeend", `
      <div class="bg-gray-100 rounded-lg p-3">
        <p class="text-xs font-medium text-gray-500">You</p>
        <p class="text-gray-900 text-sm">${this.escapeHtml(prompt)}</p>
      </div>
      <div id="loading" class="bg-blue-50 rounded-lg p-3">
        <p class="text-xs font-medium text-blue-600">Assistant</p>
        <p class="text-gray-500 text-sm">Thinking...</p>
      </div>
    `)

    // Clear input after form data is captured, then scroll
    setTimeout(() => {
      this.inputTarget.value = ""
      this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
    }, 0)
  }

  escapeHtml(text) {
    const div = document.createElement("div")
    div.textContent = text
    return div.innerHTML
  }
}
