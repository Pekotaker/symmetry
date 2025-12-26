// Vite entrypoint for Rails
import './application.css'

import * as Turbo from '@hotwired/turbo'
Turbo.start()

// Action Text
import "trix"
import "@rails/actiontext"
import "trix/dist/trix.css"

// Stimulus controllers
import "../controllers"
