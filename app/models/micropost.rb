class Micropost < ActiveRecord::Base
   #Ассоциация many2any
  belongs_to :user;
  # Упорядочивание сообщений
  default_scope -> {order('created_at DESC')} 
  #Проверка на валидность
  validates(:content, presence: true, length: {maximum: 140, minimum:3});
  validates(:user_id, presence: true);
  
  LengthText=140;

  def self.from_users_followed_by(user)
    # load all users to array 
    #   #Also user.followed_users.map(&:id)
    #   followed_users=user.followed_user_ids;
    #   where("user_id IN(?) OR user_id= (?)", followed_users,user);
    
    # Its good:
    followed_users="SELECT  followed_id FROM relationships WHERE follower_id = :user ";
    where("user_id IN(#{followed_users}) OR user_id= (:user)", user: user);
  end

end

