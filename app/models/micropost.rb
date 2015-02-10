class Micropost < ActiveRecord::Base
   #Ассоциация many2any
  belongs_to :user;
  # #for replics 
  has_and_belongs_to_many :replics_to, class_name: 'User',join_table: 'replics_users', foreign_key: 'micropost_id'
  # Упорядочивание сообщений
  default_scope -> {order('created_at DESC')};
  #Ассоциация many2many
  has_and_belongs_to_many :hashtag;
  #reposts
  has_many :reposts, class_name: "Micropost", foreign_key: "original_id", dependent: :destroy;
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
    replics_posts="SELECT micropost_id FROM replics_users WHERE user_id = (:user)"
    
    where("user_id IN(#{followed_users}) OR user_id= (:user) OR id IN(#{replics_posts}) ", user: user);
  end
  
  def reposted_count
    self.reposts.count
  end

  def repost?
    !self.original_id.nil?
  end

  def original
    if (self.repost?)
      Micropost.find(self.original_id);
    else
      self
    end
  end
  def author
    if(self.repost?)
      User.find(self.original().user_id);
    else
      User.find(self.user_id);
    end
  end

  def reposted_by?(user)
    self.reposts.map{|x| x.user_id}.include?(user.id)
  end
  
  def self.make_repost(user, original)
   user = user.id if  user.instance_of? User;
    Micropost.create(user_id:user,
        content: original.content,
        original_id:original.original.id
    );
  end
  def make_repost(user)
   #user = user.id if  user.instance_of? User;
   # Micropost.create(user_id:user,
   #     content: self.content,
   #     original_id:self.id
   # );
    Micropost.make_repost(user,self);
  end
  
  def repost_possible? (user)
    !(self.author==user ||\
     self.reposted_by?(user) || \
    self.user_id==user.id || \
    self.original.reposted_by?(user))
  end

  def self.top_rated(lim)
    count_repost="SELECT COUNT(*) FROM microposts WHERE microposts.original_id=x.id";
    Micropost.find_by_sql("SELECT * FROM microposts x  ORDER BY (#{count_repost}) DESC, created_at ASC  limit #{lim};");
  end

  def self.page_for_user(user, post)
    post=post.id if post.instance_of? Micropost;
    ind=user.micropost_ids.find_index(post);
    if(ind)
      (ind/Micropost.per_page)+1;
    else
      0
    end
  end

end

