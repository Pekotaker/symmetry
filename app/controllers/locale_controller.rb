class LocaleController < ApplicationController
  def update
    locale = params[:locale]&.to_sym

    if I18n.available_locales.include?(locale)
      cookies[:locale] = { value: locale, expires: 1.year.from_now }

      # Get the referrer URL and update/remove the locale parameter
      referrer = request.referrer || root_path
      uri = URI.parse(referrer)

      # Parse existing query params and update the locale
      query_params = Rack::Utils.parse_query(uri.query || "")
      if locale == I18n.default_locale
        query_params.delete("locale")
      else
        query_params["locale"] = locale.to_s
      end

      uri.query = query_params.empty? ? nil : Rack::Utils.build_query(query_params)
      redirect_to uri.to_s, allow_other_host: false
    else
      redirect_back(fallback_location: root_path)
    end
  end
end
