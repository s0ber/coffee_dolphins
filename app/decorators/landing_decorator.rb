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
    text = object.description_text.presence || 'Текст с описанием товара.'

    if object.video_id
      text = add_video_to_text(text)
    end

    add_images_to_text(text)
  end

  def advantages_title
    object.advantages_title.presence || 'Заголовок блока с преимуществами товара'
  end

  def advantages_text
    text = object.advantages_text.presence || "<div class=\"columns\">" +
                                                "<div class=\"column is-10 offset is-by_3\">Текст с описанием преимуществ товара.</div>" +
                                              "</div>"
    add_images_to_text(text)
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

private

  def add_video_to_text(text)
    text.sub(/%VIDEO%/) do |s|
      video_iframe_tag = "<iframe src=\"//www.youtube.com/embed/#{object.video_id}\" frameborder=\"0\" allowfullscreen=\"true\"></iframe>"
      h.content_tag(:span, video_iframe_tag.html_safe, class: 'section-video')
    end
  end

  def add_images_to_text(text)
    text.gsub(/%IMAGE_(\d+)%/) do |s|
      landing_image = LandingImage.find_by_id($1)
      if landing_image.nil?
        h.content_tag :div, "Картинки с ID #{$1} не существует", class: 'empty_image'
      else
        "<img src=\"#{landing_image.image.gallery.url}\" alt=\"#{landing_image.alt_text}\" />"
      end
    end
  end
end
