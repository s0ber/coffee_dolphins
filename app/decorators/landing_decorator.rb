class LandingDecorator < ApplicationDecorator
  decorates_association :position

  def edit_button
    h.link_to(h.fa_icon('pencil'), h.edit_landing_path(object), class: 'small_button is-icon')
  end

  def public_path
    h.public_landing_path(object.category.slug, object.slug)
  end

  def public_button
    h.link_to 'Показать черновик &rarr;'.html_safe, public_path, class: 'small_button', target: '_blank'
  end

  def human_status
    h.content_tag :b, (object.draft? ? 'Черновик' : 'Опубликован')
  end

  def title
    object.title.presence || 'Заголовок товара'
  end

  def short_description
    object.short_description.presence || 'Краткое описание товара.'
  end

  def why_question
    object.why_question.presence || 'Вопрос "Почему?".'
  end

  def description_title
    object.description_title.presence || 'Заголовок блока с описанием товара'
  end

  def description_text
    if !object.description_text.blank? && object.video_id
      video_iframe_tag = "<iframe src=\"//www.youtube.com/embed/#{object.video_id}\" frameborder=\"0\" allowfullscreen=\"true\"></iframe>"
      text = object.description_text.presence.sub('%VIDEO%', h.content_tag(:div, video_iframe_tag.html_safe, class: 'section-video'))
    else
      text = object.description_text
    end

    h.simple_format(text.presence || 'Текст с описанием товара.', {class: 'section-text'}, sanitize: false)
  end

  def advantages_title
    object.advantages_title.presence || 'Заголовок блока с преимуществами товара'
  end

  def reviews_title
    object.reviews_title.presence || 'Заголовок блока с отзывами'
  end

  def footer_title
    object.footer_title.presence || 'Заголовок нижнего блока с формой заказа'
  end

protected

  def confirm_remove_message
    "Удалить лендинг #{object.title}?"
  end
end
