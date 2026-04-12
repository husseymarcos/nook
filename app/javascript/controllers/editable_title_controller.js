import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String
  }

  edit(event) {
    const element = event.currentTarget
    const currentTitle = element.textContent.trim()
    
    // Create input element
    const input = document.createElement("input")
    input.type = "text"
    input.value = currentTitle
    input.className = "font-['Epilogue'] text-xl font-semibold bg-white border border-[#004be2] rounded-lg px-2 py-1 outline-none w-full"
    
    // Replace text with input
    element.replaceWith(input)
    input.focus()
    input.select()
    
    // Handle save on blur or enter
    const save = async () => {
      const newTitle = input.value.trim()
      if (newTitle && newTitle !== currentTitle) {
        try {
          const response = await fetch(this.urlValue, {
            method: "PATCH",
            headers: {
              "Content-Type": "application/json",
              "X-CSRF-Token": document.querySelector('[name="csrf-token"]').content
            },
            body: JSON.stringify({ title: newTitle })
          })
          
          if (response.ok) {
            element.textContent = newTitle
          }
        } catch (error) {
          console.error("Failed to update title:", error)
        }
      }
      
      input.replaceWith(element)
    }
    
    input.addEventListener("blur", save)
    input.addEventListener("keydown", (e) => {
      if (e.key === "Enter") {
        e.preventDefault()
        input.blur()
      }
      if (e.key === "Escape") {
        input.value = currentTitle
        input.blur()
      }
    })
  }
}
