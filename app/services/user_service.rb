class UserService
  def initialize(params)
    @params = params
  end

  def create
    User.create!(@params)
  end

  class << self
    def sign_out(current_user)
      current_user.update_columns(authentication_token: nil)
    end
  end
end
