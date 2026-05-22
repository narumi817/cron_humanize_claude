module ApplicationHelper
  def locale_path(base, **options)
    I18n.locale == :en ? send(:"en_#{base}_path", **options) : send(:"#{base}_path", **options)
  end
end
