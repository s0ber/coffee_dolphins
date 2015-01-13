class Public::PagesController < Public::BaseController
  def privacy
    render_modal('Политика конфиденциальности')
  end
end
