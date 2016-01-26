class UserSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :email, :description, :can_destroy

  def can_destroy
    !object.admin?
  end
end
