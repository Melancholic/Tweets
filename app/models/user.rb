VALID_EMAIL_REGEX =  /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
VALID_NAME_REGEX = /\A[a-z \d \- \_]*[a-z \- \_]+[a-z \d \- \_]*\z/i
class User < ActiveRecord::Base
  validates(:name, presence: true, length:{maximum:15,minimum:3},format: {with: VALID_NAME_REGEX});
  validates(:email, presence: true, length:{maximum:50,minimum:3},
      format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false});
  before_save{
    self.email=email.downcase;
  }
end
