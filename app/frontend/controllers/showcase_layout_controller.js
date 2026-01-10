import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "buttonSide", "buttonStack", "media", "content"]
  static values = { layout: { type: String, default: "side" } }

  connect() {
    // Load saved preference from localStorage
    const saved = localStorage.getItem("showcaseLayout")
    if (saved) {
      this.layoutValue = saved
    }
    this.updateLayout()
  }

  switchToSide() {
    this.layoutValue = "side"
    localStorage.setItem("showcaseLayout", "side")
    this.updateLayout()
  }

  switchToStack() {
    this.layoutValue = "stack"
    localStorage.setItem("showcaseLayout", "stack")
    this.updateLayout()
  }

  updateLayout() {
    const isSide = this.layoutValue === "side"

    // Update button states
    if (this.hasButtonSideTarget) {
      this.buttonSideTarget.classList.toggle("bg-amber-500", isSide)
      this.buttonSideTarget.classList.toggle("text-white", isSide)
      this.buttonSideTarget.classList.toggle("bg-zinc-800", !isSide)
      this.buttonSideTarget.classList.toggle("text-zinc-400", !isSide)
    }

    if (this.hasButtonStackTarget) {
      this.buttonStackTarget.classList.toggle("bg-amber-500", !isSide)
      this.buttonStackTarget.classList.toggle("text-white", !isSide)
      this.buttonStackTarget.classList.toggle("bg-zinc-800", isSide)
      this.buttonStackTarget.classList.toggle("text-zinc-400", isSide)
    }

    // Update container layout
    if (this.hasContainerTarget) {
      if (isSide) {
        this.containerTarget.classList.add("lg:grid-cols-2")
        this.containerTarget.classList.remove("grid-cols-1")
      } else {
        this.containerTarget.classList.remove("lg:grid-cols-2")
        this.containerTarget.classList.add("grid-cols-1")
      }
    }

    // Update media sizing
    if (this.hasMediaTarget) {
      if (isSide) {
        this.mediaTarget.classList.add("aspect-square")
        this.mediaTarget.classList.remove("aspect-video", "max-w-4xl", "mx-auto")
      } else {
        this.mediaTarget.classList.remove("aspect-square")
        this.mediaTarget.classList.add("aspect-video", "max-w-4xl", "mx-auto")
      }
    }

    // Update content container
    if (this.hasContentTarget) {
      if (isSide) {
        this.contentTarget.classList.add("max-h-[calc(100vh-200px)]")
        this.contentTarget.classList.remove("max-h-96")
      } else {
        this.contentTarget.classList.remove("max-h-[calc(100vh-200px)]")
        this.contentTarget.classList.add("max-h-96")
      }
    }
  }
}
