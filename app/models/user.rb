VALID_EMAIL_REGEX =  /\A[\w+\-.0-9]+@([a-z\d\-]+(\.[a-z\d]+)*\.[a-z]+)+\z/i
VALID_NAME_REGEX = /\A[a-z \d \- \_]*[a-z \- \_]+[a-z \d \- \_]*\z/i
class User < ActiveRecord::Base
  validates(:name, presence: true, length:{maximum:15,minimum:3},format: {with: VALID_NAME_REGEX});
  validates(:email, presence: true, length:{maximum:50,minimum:3},
      format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false});
  
  before_save{
    self.email=email.downcase;
  }
  
  before_create :create_remember_token;
  
  has_secure_password();
  validates(:password,length:{minimum:5}, confirmation: true, on: :create);
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64;
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

private
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token());
  end
end