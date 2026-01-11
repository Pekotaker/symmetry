class Users::SessionsController < Devise::SessionsController
  layout 'auth'
  # Override create to handle unconfirmed users
  def create
    # First check if user exists and is unconfirmed (before Warden handles it)
    attempted_email = params.dig(:user, :email)
    user = User.find_by(email: attempted_email)

    if user && !user.confirmed?
      # User exists but email not confirmed - show resend option
      flash.now[:unconfirmed_email] = attempted_email
      flash.now[:alert] = t('devise.failure.unconfirmed')
      self.resource = resource_class.new(email: attempted_email)
      render :new, status: :unprocessable_entity
    else
      # Let Devise handle normal authentication (wrong password, no user, etc.)
      super
    end
  end

  private

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || authenticated_root_path
  end
end
