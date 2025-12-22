module SvgHelper
  def inline_svg(filename, options = {})
    file_path = Rails.root.join("app", "assets", "images", "icons", "#{filename}.svg")

    return "" unless File.exist?(file_path)

    svg_content = File.read(file_path)

    # Add CSS classes if provided
    if options[:class].present?
      svg_content = svg_content.sub("<svg", "<svg class=\"#{options[:class]}\"")
    end

    svg_content.html_safe
  end
end

