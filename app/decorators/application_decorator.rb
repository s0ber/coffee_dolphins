class ApplicationDecorator < Draper::Decorator
  BLANK_VALUE = '—'
  delegate_all

  def like_button
    h.content_tag :span, h.fa_icon('heart') + h.fa_icon('heart-o'),
      class: "small_button is-icon is-like #{'is-liked' if object.liked?}",
      remote: true,
      method: :put,
      data: {view: 'app#like_button',
             like_path: h.polymorphic_path(object, action: :like),
             unlike_path: h.polymorphic_path(object, action: :unlike)}
  end
end

