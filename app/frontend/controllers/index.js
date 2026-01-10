import { Application } from "@hotwired/stimulus"
import QuizAnswersController from "./quiz_answers_controller"
import ImagePreviewController from "./image_preview_controller"
import QuizController from "./quiz_controller"
import PuzzleEntriesController from "./puzzle_entries_controller"
import ReflectionPuzzleController from "./reflection_puzzle_controller"
import VideoPreviewController from "./video_preview_controller"
import ShowcaseLayoutController from "./showcase_layout_controller"

const application = Application.start()

application.register("quiz-answers", QuizAnswersController)
application.register("image-preview", ImagePreviewController)
application.register("quiz", QuizController)
application.register("puzzle-entries", PuzzleEntriesController)
application.register("reflection-puzzle", ReflectionPuzzleController)
application.register("video-preview", VideoPreviewController)
application.register("showcase-layout", ShowcaseLayoutController)

export { application }

