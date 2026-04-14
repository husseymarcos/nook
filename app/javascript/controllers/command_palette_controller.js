import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "input"]

  connect() {
    window.addEventListener("keydown", this.handleKeydown.bind(this), { capture: true })
  }

  disconnect() {
    window.removeEventListener("keydown", this.handleKeydown.bind(this), { capture: true })
  }

  handleKeydown(event) {
    if ((event.metaKey || event.ctrlKey) && event.key === "k") {
      event.preventDefault()
      this.isOpen ? this.close() : this.open()
      return
    }

    if (event.key === "Escape") {
      event.stopImmediatePropagation()
      event.preventDefault()
      if (this.isOpen) this.close()
    }
  }

  open() {
    this.modalTarget.classList.add("command-palette--open")
    this.inputTarget.focus()
  }

  close() {
    this.modalTarget.classList.remove("command-palette--open")
    this.inputTarget.value = ""
  }

  get isOpen() {
    return this.modalTarget.classList.contains("command-palette--open")
  }

  clickOutside(event) {
    if (event.target === this.modalTarget) {
      this.close()
    }
  }
}
