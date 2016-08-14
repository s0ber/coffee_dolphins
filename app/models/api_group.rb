class ApiGroup < ActiveRecord::Base
  validates :title, :description, presence: true
end
