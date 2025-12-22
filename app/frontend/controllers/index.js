import { Application } from "@hotwired/stimulus"
import QuizAnswersController from "./quiz_answers_controller"
import ImagePreviewController from "./image_preview_controller"
import QuizController from "./quiz_controller"

const application = Application.start()

application.register("quiz-answers", QuizAnswersController)
application.register("image-preview", ImagePreviewController)
application.register("quiz", QuizController)

export { application }

