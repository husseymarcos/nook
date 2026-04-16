import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  handleKeydown(event) {
    if (this.isSubmitShortcut(event)) {
      event.preventDefault()
      this.submitForm()
    }
  }

  submitForm() {
    const form = this.element

    if (typeof form.requestSubmit === "function") {
      form.requestSubmit()
    } else {
      form.dispatchEvent(new Event("submit", { bubbles: true }))
    }
  }

  isSubmitShortcut(event) {
    return event.key === "Enter" && event.shiftKey
  }
}
