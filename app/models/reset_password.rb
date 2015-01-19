class ResetPassword < ActiveRecord::Base
  before_create{
    self.password_key=SecureRandom.urlsafe_base64;
  }

  def getUser()
    User.find(self.user_id);
  end
  def self.getUser(key)
    rp=ResetPassword.find_by(password_key: key.to_s);
    if(rp)
      User.find(rp.user_id);
    else
      nil
    end
  end
end
