class Anonymous
  def self.user
    @user ||= Anonymous.new
  end
end
