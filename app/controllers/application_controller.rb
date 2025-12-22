class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_root_path
    else
      super
    end
  end

  def set_locale
    I18n.locale = locale_from_params || locale_from_cookie || locale_from_header || I18n.default_locale
    cookies[:locale] = { value: I18n.locale, expires: 1.year.from_now } if locale_from_params
  end

  def default_url_options
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end

  private

  def locale_from_params
    params[:locale] if params[:locale].present? && I18n.available_locales.map(&:to_s).include?(params[:locale])
  end

  def locale_from_cookie
    cookies[:locale]&.to_sym if cookies[:locale].present? && I18n.available_locales.include?(cookies[:locale]&.to_sym)
  end

  def locale_from_header
    request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first&.to_sym.tap do |locale|
      return locale if locale && I18n.available_locales.include?(locale)
    end
    nil
  end

  def user_not_authorized
    flash[:alert] = t("admin.access_denied")
    redirect_back(fallback_location: root_path)
  end
end
