class Public::PagesController < Public::BaseController
  def home
    @landings = Landing.published.includes(:position, :landing_images).decorate
  end

  def privacy
    render_modal('Политика конфиденциальности')
  end

  def about
    render_modal('О нашем магазине')
  end

  def delivery
    render_modal('Информация о доставке')
  end

  def guarantees
    render_modal('Гарантийные обязательства')
  end

  def faq
    render_modal('Вопросы и ответы')
  end
end
