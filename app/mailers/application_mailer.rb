class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_FROM", "Symmetry <noreply@symmetry.app>")
  layout "mailer"
end
