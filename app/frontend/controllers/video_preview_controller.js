import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "video", "placeholder", "filename"]

  connect() {
    this.boundPreview = this.preview.bind(this)
    this.inputTarget.addEventListener("change", this.boundPreview)
  }

  disconnect() {
    this.inputTarget.removeEventListener("change", this.boundPreview)
    // Revoke object URL to free memory
    if (this.objectUrl) {
      URL.revokeObjectURL(this.objectUrl)
    }
  }

  preview(event) {
    const file = event.target.files[0]
    
    if (file) {
      // Revoke previous URL if exists
      if (this.objectUrl) {
        URL.revokeObjectURL(this.objectUrl)
      }

      // Create object URL for the video (more efficient than FileReader for videos)
      this.objectUrl = URL.createObjectURL(file)
      
      // Update video source and show video
      this.videoTarget.src = this.objectUrl
      this.videoTarget.classList.remove("hidden")
      this.videoTarget.load() // Reload the video with new source
      
      // Hide placeholder
      if (this.hasPlaceholderTarget) {
        this.placeholderTarget.classList.add("hidden")
      }

      // Show filename
      if (this.hasFilenameTarget) {
        this.filenameTarget.textContent = file.name
        this.filenameTarget.classList.remove("hidden")
      }
    }
  }
}
