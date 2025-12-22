class Users::RegistrationsController < Devise::RegistrationsController
  layout :resolve_layout

  protected

  # Redirect to sign-in page after sign-up (since user needs to confirm email)
  def after_inactive_sign_up_path_for(resource)
    new_user_session_path
  end

  private

  def resolve_layout
    user_signed_in? ? 'application' : 'auth'
  end
end
