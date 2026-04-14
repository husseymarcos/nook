import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "input"]

  connect() {
    document.addEventListener("keydown", this.handleKeydown)
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleKeydown)
  }

  handleKeydown = (event) => {
    if (this.isToggleShortcut(event)) {
      event.preventDefault()
      this.toggle()
    } else if (this.isEscapeKey(event)) {
      event.preventDefault()
      this.close()
    }
  }

  toggle() {
    this.isOpen ? this.close() : this.open()
  }

  open() {
    this.modalTarget.classList.add("command-palette--open")
    this.inputTarget.focus()
  }

  close() {
    this.modalTarget.classList.remove("command-palette--open")
    this.inputTarget.value = ""
  }

  clickOutside(event) {
    if (event.target === this.modalTarget) {
      this.close()
    }
  }

  isToggleShortcut(event) {
    return (event.metaKey || event.ctrlKey) && event.key === "k"
  }

  isEscapeKey(event) {
    return event.key === "Escape" && this.isOpen
  }

  get isOpen() {
    return this.modalTarget.classList.contains("command-palette--open")
  }
}
