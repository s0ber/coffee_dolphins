class LandingDecorator < ApplicationDecorator
  decorates_association :position

  def edit_button
    h.link_to(h.fa_icon('pencil'), h.edit_landing_path(object), class: 'small_button is-icon')
  end

  def public_path
    h.public_landing_path(object.slug)
  end

  def success_path
    h.public_landing_success_path(object.slug)
  end

  def public_button
    h.link_to "Показать #{object.published? ? 'опубликованный лендинг' : 'черновик'} &rarr;".html_safe, public_path, class: 'small_button', target: '_blank'
  end

  def apishops_button
    unless object.apishops_site_id.nil?
      h.link_to 'Открыть на Apishops.com &rarr;'.html_safe, "http://www.apishops.com/Webmaster/Website/SiteProducts.jsp?siteId=#{object.apishops_site_id}", class: 'small_button', target: '_blank'
    end
  end

  def public_price
    (object.price.presence || object.position.price).to_i
  end

  def public_price_without_discount
    ((public_price / (100.to_f - object.discount.to_f)) * 100).to_i.round(-1)
  end

  def discount
    public_price_without_discount - public_price
  end

  def human_status
    h.content_tag :b, (object.draft? ? 'Черновик' : '<span class="status is-green">Опубликован</span>'.html_safe)
  end

  def html_title
    object.html_title.presence || 'SaveMoneyShop.Ru&trade; — уникальные товары по уникальным ценам.'
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

  def reviews_footer
    object.reviews_footer.presence || 'Футер блока с отзывами, должен содержать финальное побуждение к покупке'
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
