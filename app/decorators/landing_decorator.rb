class LandingDecorator < ApplicationDecorator
  decorates_association :position

  def public_path
    h.public_landing_path(object.category.slug, object.slug)
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
    h.simple_format(object.description_text.presence || 'Текст с описанием товара.', class: 'section-text')
  end

  def advantages_title
    object.advantages_title.presence || 'Заголовок блока с преимуществами товара'
  end

protected

  def confirm_remove_message
    "Удалить лендинг #{object.title}?"
  end
end
