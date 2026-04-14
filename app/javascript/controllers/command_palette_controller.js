import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "input"]

  connect() {
    this.boundHandleKeydown = this.handleKeydown.bind(this)
    window.addEventListener("keydown", this.boundHandleKeydown)
  }

  disconnect() {
    window.removeEventListener("keydown", this.boundHandleKeydown)
  }

  handleKeydown(event) {
    if ((event.metaKey || event.ctrlKey) && event.key === "k") {
      event.preventDefault()
      this.isOpen ? this.close() : this.open()
      return
    }

    if (event.key === "Escape" && this.isOpen) {
      event.preventDefault()
      this.close()
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
