module ApplicationHelper
  def locale_path(base, **options)
    I18n.locale == :en ? send(:"en_#{base}_path", **options) : send(:"#{base}_path", **options)
  end

  def lang_switch_path
    base = case controller_name
    when "cron_builder" then :build
    when "pages"        then action_name.to_sym
    else                     :root
    end
    I18n.locale == :en ? send(:"#{base}_path") : send(:"en_#{base}_path")
  end
end
