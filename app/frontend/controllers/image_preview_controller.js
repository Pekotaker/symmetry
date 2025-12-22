import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "placeholder"]

  connect() {
    this.boundPreview = this.preview.bind(this)
    this.inputTarget.addEventListener("change", this.boundPreview)
  }

  disconnect() {
    this.inputTarget.removeEventListener("change", this.boundPreview)
  }

  preview(event) {
    const file = event.target.files[0]
    
    if (file) {
      const reader = new FileReader()
      
      reader.onload = (e) => {
        // Show preview, hide placeholder
        this.previewTarget.src = e.target.result
        this.previewTarget.classList.remove("hidden")
        if (this.hasPlaceholderTarget) {
          this.placeholderTarget.classList.add("hidden")
        }
      }
      
      reader.readAsDataURL(file)
    }
  }
}

