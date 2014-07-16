VALID_EMAIL_REGEX =  /\A[\w+\-.0-9]+@([a-z\d\-]+(\.[a-z\d]+)*\.[a-z]+)+\z/i
VALID_NAME_REGEX = /\A[a-z \d \- \_]*[a-z \- \_]+[a-z \d \- \_]*\z/i
class User < ActiveRecord::Base
  #Ассоциация any2many
  has_many(:microposts, dependent: :destroy);
  
  has_many(:relationships, foreign_key: "follower_id", dependent: :destroy);
  has_many(:followed_users, through: :relationships, source: :followed);
  
  has_many(:reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy);
  has_many(:followers, through: :reverse_relationships, source: :follower);

  #Порядок
  default_scope -> {order('name ASC')}

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
  
  def feed
  # only self posts
  #also microposts
  #Micropost.where("user_id=?",id);
  
  #Post by other users 
  Micropost.from_users_followed_by(self);
 end

 def following?(other_usr)
    self.relationships.find_by(followed_id:other_usr.id);
 end

 def follow!(other_usr)
    self.relationships.create!(followed_id: other_usr.id);
 end

 def unfollow!(other_usr)
    self.relationships.find_by(followed_id: other_usr.id).destroy!;
 end

  

private
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token());
  end
end
