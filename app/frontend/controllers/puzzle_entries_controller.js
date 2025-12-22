import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "entry"]
  static values = { url: String }

  addEntry() {
    // Use timestamp to ensure unique index (avoids collision with existing entries)
    const index = new Date().getTime()

    // Handle URL that may already have query params (e.g., ?locale=vi)
    const separator = this.urlValue.includes('?') ? '&' : '?'
    const url = `${this.urlValue}${separator}index=${index}`

    fetch(url, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Accept": "text/html"
      }
    })
      .then(response => response.text())
      .then(html => {
        this.containerTarget.insertAdjacentHTML("beforeend", html)
      })
  }

  removeEntry(event) {
    const entryRow = event.target.closest(".entry-row")
    const destroyField = entryRow.querySelector(".destroy-field")

    if (destroyField) {
      // Mark for destruction (existing record)
      destroyField.value = "true"
      entryRow.classList.add("hidden")
    } else {
      // Remove from DOM (new record)
      entryRow.remove()
    }
  }
}

