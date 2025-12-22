// Vite entrypoint for Rails
import './application.css'

import * as Turbo from '@hotwired/turbo'
Turbo.start()

// Stimulus controllers
import "../controllers"
