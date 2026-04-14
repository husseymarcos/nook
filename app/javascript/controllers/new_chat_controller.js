import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "modelSelect"]

  fillPrompt(event) {
    const prompt = event.currentTarget.dataset.prompt
    this.inputTarget.value = prompt
    this.inputTarget.focus()
  }

  handleKeydown(event) {
    // Submit on Enter (without Shift for new line)
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.element.requestSubmit()
    }
  }
}
