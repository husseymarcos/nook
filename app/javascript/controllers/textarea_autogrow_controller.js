import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.adjustHeight()
    this.element.addEventListener("input", this.adjustHeight.bind(this))
  }

  disconnect() {
    this.element.removeEventListener("input", this.adjustHeight.bind(this))
  }

  adjustHeight() {
    this.element.style.height = "auto"
    this.element.style.height = Math.min(this.element.scrollHeight, 128) + "px"
  }

  submitOnEnter(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.element.form.requestSubmit()
    }
  }
}
