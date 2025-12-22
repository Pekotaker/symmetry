import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "row"]
  static values = { url: String }

  connect() {
    this.updateLetters()
  }

  async addAnswer() {
    const index = this.rowTargets.length
    
    try {
      const response = await fetch(this.urlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "text/html",
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
        },
        body: JSON.stringify({ index: index })
      })
      
      if (response.ok) {
        const html = await response.text()
        this.containerTarget.insertAdjacentHTML("beforeend", html)
      }
    } catch (error) {
      console.error("Failed to add answer:", error)
    }
  }

  removeAnswer(event) {
    const row = event.target.closest("[data-quiz-answers-target='row']")
    if (this.rowTargets.length > 1) {
      row.remove()
      this.updateLetters()
    }
  }

  updateLetters() {
    this.rowTargets.forEach((row, index) => {
      const letter = String.fromCharCode(65 + index)
      const letterBox = row.querySelector(".flex.h-10.w-10")
      if (letterBox) {
        letterBox.textContent = letter
      }
      
      const checkbox = row.querySelector("input[type='checkbox']")
      if (checkbox) {
        checkbox.value = index
      }
    })
  }
}
