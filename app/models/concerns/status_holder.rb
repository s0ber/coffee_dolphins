module StatusHolder
  extend ActiveSupport::Concern

  def status
    self._status.try(:to_sym)
  end
end
