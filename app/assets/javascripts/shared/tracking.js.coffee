GOALS = [
  '15_sec'
  'middle_page_scrolled'
  'bottom_page_scrolled'
  'order_form_opened'
  'order_successed'
  'cart_protector_shown'
  'cart_protector_email_received'
]

EVENTS = []

class Tracking

  trackEvent: (eventName) ->
    allowedGoal = _.indexOf(GOALS, eventName) != -1
    allowedEvent = _.indexOf(EVENTS, eventName) != -1

    return if !allowedGoal and !allowedEvent

    if allowedGoal
      @ga()?('send', 'event', 'goal', eventName)
      @yac()?.reachGoal(eventName)

  ga: ->
    window['ga']

  yac: ->
    window["yaCounter#{gon.yandex_metrika_app_id}"]

@tracking = new Tracking()
