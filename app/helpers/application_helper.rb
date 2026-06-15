module ApplicationHelper
  def locale_path(base, **options)
    I18n.locale == :en ? send(:"en_#{base}_path", **options) : send(:"#{base}_path", **options)
  end

  def lang_switch_path
    base = current_page_base
    I18n.locale == :en ? send(:"#{base}_path") : send(:"en_#{base}_path")
  end

  def locale_url_for(locale)
    base = current_page_base
    locale == :en ? send(:"en_#{base}_url") : send(:"#{base}_url")
  end

  private

  def current_page_base
    case controller_name
    when "cron_builder" then :build
    when "pages"        then action_name.to_sym
    else                     :root
    end
  end
end
