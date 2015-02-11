require 'rails_helper'

describe ResetPassword do
  before {@user= FactoryGirl.create(:user); 
    @rp = @user.make_reset_password(host:"127.0.0.1")
  }
  subject {@rp}
  #тест наличия
  it{ should respond_to(:user_id) }
  it{ should respond_to(:password_key) }
  it{ should respond_to(:host) }
  it{ should respond_to(:getUser) }
end
