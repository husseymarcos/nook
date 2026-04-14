import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "input"]

  connect() {
    this.boundKeydown = this.handleKeydown.bind(this)
    document.addEventListener("keydown", this.boundKeydown)
    this.isOpen = false
  }

  disconnect() {
    document.removeEventListener("keydown", this.boundKeydown)
  }

  handleKeydown(event) {
    if ((event.metaKey || event.ctrlKey) && event.key === "k") {
      event.preventDefault()
      if (this.isOpen) {
        this.close()
      } else {
        this.open()
      }
    }

    if (event.key === "Escape" && this.isOpen) {
      this.close()
    }
  }

  open() {
    this.isOpen = true
    this.modalTarget.classList.add("command-palette--open")
    this.inputTarget.focus()
  }

  close() {
    this.isOpen = false
    this.modalTarget.classList.remove("command-palette--open")
    this.inputTarget.value = ""
  }

  clickOutside(event) {
    if (event.target === this.modalTarget) {
      this.close()
    }
  }
}
