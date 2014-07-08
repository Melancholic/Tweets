class Micropost < ActiveRecord::Base
  validates(:user_id, presence: true);
  #Ассоциация many2any
  belongs_to :user;
  # Упорядочивание сообщений
  default_scope -> {order('created_at DESC')}
end
