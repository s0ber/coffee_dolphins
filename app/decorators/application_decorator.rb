class ApplicationDecorator < Draper::Decorator
  BLANK_VALUE = '—'
  delegate_all
end

