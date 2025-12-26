import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "leftColumn", "rightColumn",
    "leftImage", "rightImage",
    "leftCanvas", "rightCanvas",
    "leftCanvasImage", "rightCanvasImage",
    "leftPlaceholder", "rightPlaceholder",
    "canvas", "feedback", "feedbackIcon",
    "score", "remaining",
    "glowLine", "triviaModal", "triviaContent"
  ]
  static values = { entries: Array }

  connect() {
    this.selectedLeftEntryId = null
    this.selectedRightEntryId = null
    this.matchedEntryIds = new Set()
    this.score = 0
    this.pendingTrivia = null
  }

  selectLeftImage(event) {
    const button = event.currentTarget
    const entryId = parseInt(button.dataset.entryId)
    
    // Skip if already matched
    if (this.matchedEntryIds.has(entryId)) return

    // Update selection state
    this.leftImageTargets.forEach(img => {
      img.classList.remove("border-amber-500", "shadow-amber-500/25", "shadow-lg")
      img.classList.add("border-zinc-700")
    })
    button.classList.remove("border-zinc-700")
    button.classList.add("border-amber-500", "shadow-amber-500/25", "shadow-lg")

    // Update canvas
    const img = button.querySelector("img")
    const fullSrc = img.dataset.src || img.src
    this.leftCanvasImageTarget.src = fullSrc
    this.leftCanvasImageTarget.classList.remove("hidden")
    this.leftPlaceholderTarget.classList.add("hidden")

    this.selectedLeftEntryId = entryId
    this.checkMatch()
  }

  selectRightImage(event) {
    const button = event.currentTarget
    const entryId = parseInt(button.dataset.entryId)
    
    // Skip if already matched
    if (this.matchedEntryIds.has(entryId)) return

    // Update selection state
    this.rightImageTargets.forEach(img => {
      img.classList.remove("border-amber-500", "shadow-amber-500/25", "shadow-lg")
      img.classList.add("border-zinc-700")
    })
    button.classList.remove("border-zinc-700")
    button.classList.add("border-amber-500", "shadow-amber-500/25", "shadow-lg")

    // Update canvas
    const img = button.querySelector("img")
    const fullSrc = img.dataset.src || img.src
    this.rightCanvasImageTarget.src = fullSrc
    this.rightCanvasImageTarget.classList.remove("hidden")
    this.rightPlaceholderTarget.classList.add("hidden")

    this.selectedRightEntryId = entryId
    this.checkMatch()
  }

  checkMatch() {
    if (this.selectedLeftEntryId === null || this.selectedRightEntryId === null) {
      return
    }

    const isMatch = this.selectedLeftEntryId === this.selectedRightEntryId

    if (isMatch) {
      this.handleCorrectMatch()
    } else {
      this.handleIncorrectMatch()
    }
  }

  handleCorrectMatch() {
    // Show success feedback with glow
    this.showFeedback(true)
    this.showGlowEffect()

    // Mark entry as matched
    const entryId = this.selectedLeftEntryId
    this.matchedEntryIds.add(entryId)

    // Update score
    this.score++
    this.scoreTarget.textContent = this.score
    this.remainingTarget.textContent = this.entriesValue.length - this.score

    // Disable matched images
    this.leftImageTargets.forEach(img => {
      if (parseInt(img.dataset.entryId) === entryId) {
        img.classList.add("opacity-30", "pointer-events-none")
        img.classList.remove("border-amber-500", "shadow-amber-500/25", "shadow-lg")
        img.classList.add("border-emerald-500/50")
      }
    })
    this.rightImageTargets.forEach(img => {
      if (parseInt(img.dataset.entryId) === entryId) {
        img.classList.add("opacity-30", "pointer-events-none")
        img.classList.remove("border-amber-500", "shadow-amber-500/25", "shadow-lg")
        img.classList.add("border-emerald-500/50")
      }
    })

    // Find the trivia for this entry
    const entry = this.entriesValue.find(e => e.id === entryId)
    
    // Show trivia popup after a short delay for feedback
    setTimeout(() => {
      this.hideFeedback()
      this.hideGlowEffect()
      
      if (entry && entry.trivia) {
        this.showTrivia(entry.trivia)
      } else {
        // No trivia, just reset
        this.resetSelection()
      }
    }, 800)
  }

  handleIncorrectMatch() {
    // Show failure feedback
    this.showFeedback(false)

    // Reset selection after a delay
    setTimeout(() => {
      this.hideFeedback()
      this.resetSelection()
    }, 1200)
  }

  showGlowEffect() {
    if (this.hasGlowLineTarget) {
      this.glowLineTarget.classList.remove("opacity-0")
      this.glowLineTarget.classList.add("opacity-100")
    }
  }

  hideGlowEffect() {
    if (this.hasGlowLineTarget) {
      this.glowLineTarget.classList.remove("opacity-100")
      this.glowLineTarget.classList.add("opacity-0")
    }
  }

  showTrivia(triviaHtml) {
    if (this.hasTriviaModalTarget && this.hasTriviaContentTarget) {
      this.triviaContentTarget.innerHTML = triviaHtml
      this.triviaModalTarget.classList.remove("hidden")
    }
  }

  closeTrivia() {
    if (this.hasTriviaModalTarget) {
      this.triviaModalTarget.classList.add("hidden")
      this.triviaContentTarget.innerHTML = ""
    }
    this.resetSelection()
  }

  showFeedback(isCorrect) {
    // Update canvas border
    if (isCorrect) {
      if (this.hasCanvasTarget) {
        this.canvasTarget.classList.add("border-emerald-500", "shadow-emerald-500/20", "shadow-xl")
      }
      if (this.hasFeedbackIconTarget) {
        this.feedbackIconTarget.textContent = "✓"
        this.feedbackIconTarget.classList.add("text-emerald-500")
        this.feedbackIconTarget.classList.remove("text-red-500")
      }
      if (this.hasLeftCanvasTarget) {
        this.leftCanvasTarget.classList.add("bg-emerald-500/10")
      }
      if (this.hasRightCanvasTarget) {
        this.rightCanvasTarget.classList.add("bg-emerald-500/10")
      }
    } else {
      if (this.hasCanvasTarget) {
        this.canvasTarget.classList.add("border-red-500", "shadow-red-500/20", "shadow-xl")
      }
      if (this.hasFeedbackIconTarget) {
        this.feedbackIconTarget.textContent = "✗"
        this.feedbackIconTarget.classList.add("text-red-500")
        this.feedbackIconTarget.classList.remove("text-emerald-500")
      }
      if (this.hasLeftCanvasTarget) {
        this.leftCanvasTarget.classList.add("bg-red-500/10")
      }
      if (this.hasRightCanvasTarget) {
        this.rightCanvasTarget.classList.add("bg-red-500/10")
      }
    }

    if (this.hasFeedbackTarget) {
      this.feedbackTarget.classList.remove("opacity-0")
      this.feedbackTarget.classList.add("opacity-100")
    }
  }

  hideFeedback() {
    if (this.hasCanvasTarget) {
      this.canvasTarget.classList.remove(
        "border-emerald-500", "shadow-emerald-500/20",
        "border-red-500", "shadow-red-500/20",
        "shadow-xl"
      )
    }
    if (this.hasFeedbackTarget) {
      this.feedbackTarget.classList.remove("opacity-100")
      this.feedbackTarget.classList.add("opacity-0")
    }
    if (this.hasLeftCanvasTarget) {
      this.leftCanvasTarget.classList.remove("bg-emerald-500/10", "bg-red-500/10")
    }
    if (this.hasRightCanvasTarget) {
      this.rightCanvasTarget.classList.remove("bg-emerald-500/10", "bg-red-500/10")
    }
  }

  resetSelection() {
    // Clear canvas
    this.leftCanvasImageTarget.classList.add("hidden")
    this.rightCanvasImageTarget.classList.add("hidden")
    this.leftPlaceholderTarget.classList.remove("hidden")
    this.rightPlaceholderTarget.classList.remove("hidden")

    // Clear selections
    this.leftImageTargets.forEach(img => {
      if (!this.matchedEntryIds.has(parseInt(img.dataset.entryId))) {
        img.classList.remove("border-amber-500", "shadow-amber-500/25", "shadow-lg")
        img.classList.add("border-zinc-700")
      }
    })
    this.rightImageTargets.forEach(img => {
      if (!this.matchedEntryIds.has(parseInt(img.dataset.entryId))) {
        img.classList.remove("border-amber-500", "shadow-amber-500/25", "shadow-lg")
        img.classList.add("border-zinc-700")
      }
    })

    this.selectedLeftEntryId = null
    this.selectedRightEntryId = null
  }
}

