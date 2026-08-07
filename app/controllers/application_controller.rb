class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  around_action :switch_locale

  private

  # I18n.locale への代入はグローバルなため、同じスレッドで処理される
  # 後続のリクエストへ漏れる。with_locale でリクエスト内に閉じる
  def switch_locale(&action)
    I18n.with_locale(params[:locale].presence || I18n.default_locale, &action)
  end
end
