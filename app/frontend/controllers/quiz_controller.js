import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["answer", "feedback", "submitButton", "questionImage", "correctImage"]
  static values = { 
    correctIndices: Array,
    submitted: { type: Boolean, default: false },
    feedbackUrl: { type: String, default: "/api/quiz_feedback" }
  }

  connect() {
    this.selectedIndices = new Set()
  }

  toggleAnswer(event) {
    if (this.submittedValue) return
    
    const button = event.currentTarget
    const index = parseInt(button.dataset.index)
    
    if (this.selectedIndices.has(index)) {
      this.selectedIndices.delete(index)
      button.classList.remove("border-amber-500", "bg-amber-500/20", "ring-2", "ring-amber-500/30")
      button.classList.add("border-zinc-700", "bg-zinc-800/50")
    } else {
      this.selectedIndices.add(index)
      button.classList.remove("border-zinc-700", "bg-zinc-800/50")
      button.classList.add("border-amber-500", "bg-amber-500/20", "ring-2", "ring-amber-500/30")
    }
    
    // Enable/disable submit button based on selection
    if (this.hasSubmitButtonTarget) {
      this.submitButtonTarget.disabled = this.selectedIndices.size === 0
      if (this.selectedIndices.size > 0) {
        this.submitButtonTarget.classList.remove("opacity-50", "cursor-not-allowed")
      } else {
        this.submitButtonTarget.classList.add("opacity-50", "cursor-not-allowed")
      }
    }
  }

  submit() {
    if (this.submittedValue || this.selectedIndices.size === 0) return
    
    this.submittedValue = true
    
    // Check if selected answers match correct answers exactly
    const selectedArray = Array.from(this.selectedIndices).sort((a, b) => a - b)
    const correctArray = [...this.correctIndicesValue].sort((a, b) => a - b)
    const isCorrect = selectedArray.length === correctArray.length && 
                      selectedArray.every((val, idx) => val === correctArray[idx])
    
    // Disable all answer buttons
    this.answerTargets.forEach(target => {
      target.classList.add("pointer-events-none")
    })
    
    // Disable submit button
    if (this.hasSubmitButtonTarget) {
      this.submitButtonTarget.disabled = true
      this.submitButtonTarget.classList.add("opacity-50", "cursor-not-allowed")
    }
    
    // Highlight answers
    this.answerTargets.forEach(target => {
      const index = parseInt(target.dataset.index)
      const isSelected = this.selectedIndices.has(index)
      const isCorrectAnswer = this.correctIndicesValue.includes(index)
      
      // Remove selection styling
      target.classList.remove("border-amber-500", "bg-amber-500/20", "ring-amber-500/30")
      
      if (isCorrectAnswer) {
        // Show correct answers in green
        target.classList.remove("border-zinc-700", "bg-zinc-800/50")
        target.classList.add("border-emerald-500", "bg-emerald-500/20", "ring-2", "ring-emerald-500/30")
      } else if (isSelected) {
        // Show incorrectly selected answers in red
        target.classList.remove("border-zinc-700", "bg-zinc-800/50")
        target.classList.add("border-red-500", "bg-red-500/20", "ring-2", "ring-red-500/30")
      }
    })
    
    this.showFeedback(isCorrect)
  }
  
  showFeedback(isCorrect) {
    if (!this.hasFeedbackTarget) return
    
    // If correct and we have a correct answer image, swap the images
    if (isCorrect && this.hasCorrectImageTarget) {
      if (this.hasQuestionImageTarget) {
        this.questionImageTarget.classList.add("opacity-0")
      }
      this.correctImageTarget.classList.remove("opacity-0")
      this.correctImageTarget.classList.add("opacity-100")
    }
    
    fetch(`${this.feedbackUrlValue}?correct=${isCorrect}`, {
      headers: {
        "X-Requested-With": "XMLHttpRequest",
        "Accept": "text/html"
      }
    })
      .then(response => response.text())
      .then(html => {
        this.feedbackTarget.innerHTML = html
        this.feedbackTarget.classList.remove("hidden")
      })
      .catch(error => console.error("Error loading feedback:", error))
  }
  
  reset() {
    this.submittedValue = false
    this.selectedIndices = new Set()
    
    this.answerTargets.forEach(target => {
      target.classList.remove(
        "pointer-events-none",
        "border-emerald-500", "bg-emerald-500/20", "ring-2", "ring-emerald-500/30",
        "border-red-500", "bg-red-500/20", "ring-red-500/30",
        "border-amber-500", "bg-amber-500/20", "ring-amber-500/30"
      )
      target.classList.add("border-zinc-700", "bg-zinc-800/50")
    })
    
    if (this.hasSubmitButtonTarget) {
      this.submitButtonTarget.disabled = true
      this.submitButtonTarget.classList.add("opacity-50", "cursor-not-allowed")
    }
    
    if (this.hasFeedbackTarget) {
      this.feedbackTarget.classList.add("hidden")
      this.feedbackTarget.innerHTML = ""
    }
  }
}
