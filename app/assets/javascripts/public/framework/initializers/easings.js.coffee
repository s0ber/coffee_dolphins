baseEasings =
  Back: (p) ->
    p * p * (3.5 * p - 2)

for name, i in ['Quad', 'Cubic', 'Quart', 'Quint', 'Expo']
  baseEasings[name] = (p) ->
    Math.pow(p, i + 2)

$.each baseEasings, (name, easeIn) ->
  $.easing["easeIn#{name}"]  = easeIn
  $.easing["easeOut#{name}"] = (p) ->
    1 - easeIn(1 - p)
  $.easing[ "easeInOut#{name}" ] = (p) ->
    if p < 0.5
      easeIn(p * 2) / 2
    else
      1 - easeIn(p * -2 + 2) / 2
