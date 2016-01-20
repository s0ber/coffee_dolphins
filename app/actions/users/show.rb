class Users::Show < AStream::BaseAction
  safe_attributes :full_name, :email, :description
  permit_resource { |performer| performer }

  def perform_read(performer, query)
    User.all
  end
end

