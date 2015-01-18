#Коснтанты
VALID_EMAIL_REGEX =  /\A[\w+\-.0-9]+@([a-z\d\-]+(\.[a-z\d]+)*\.[a-z]+)+\z/i
VALID_NAME_REGEX = /\A[a-z \d \- \_]*[a-z \- \_]+[a-z \d \- \_]*\z/i
 
TYME_LIM_PASSRST_KEY =30; # Live time for key in reset password (min)
class User < ActiveRecord::Base
  
  #Ассоциация any2many
  has_many(:microposts, dependent: :destroy);
  has_and_belongs_to_many :replics_from, class_name: 'Micropost', foreign_key: 'user_id',  join_table: 'replics_users';
  has_many(:relationships, foreign_key: "follower_id", dependent: :destroy);
  has_many(:followed_users, through: :relationships, source: :followed);
  
  has_many(:reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy);
  has_many(:followers, through: :reverse_relationships, source: :follower);
  has_one :verification_user;
  has_one :reset_password;
  #Порядок
  default_scope -> {order('name ASC')}

  validates(:name, presence: true, length:{maximum:15,minimum:3},format: {with: VALID_NAME_REGEX});
  validates(:email, presence: true, length:{maximum:50,minimum:3},
      format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false});
  
  before_save{
    self.email=email.downcase;
  }
  after_create{
    #self.verification_user=VerificationUser.create(user_id: 12, verificated:false);
    self.verification_user=VerificationUser.create(user_id: self.id, verificated:false);
  }

  before_create :create_remember_token;
  
  has_secure_password();
  #validates(:password,length:{minimum:5}, confirmation: true, on: :create);
   validates :password, :presence => true,
                       :confirmation => true,
                       :length => {:within => 6..40},
                       :on => :create
   validates :password, :confirmation => true,
                       :length => {:within => 6..40},
                       :allow_blank => true,
                       :on => :update
  
  def self.get_regex
     return /[@][a-zA-Zа-яА-Я0-9\_]+/;
  end
  
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

  def verificated?()
    self.verification_user.verificated
  end

  def verification_key()
    self.verification_user.verification_key
  end

  def reset_password_key()
    if(self.reset_password)
      self.reset_password.password_key
    else
      nil
    end
  end
  def make_reset_password(args)
    if(self.reset_password)
      self.reset_password.delete;
      self.create_reset_password(args);
    else
      self.create_reset_password();
    end
  end
private
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token());
  end
end
