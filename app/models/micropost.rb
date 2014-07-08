class Micropost < ActiveRecord::Base
   #Ассоциация many2any
  belongs_to :user;
  # Упорядочивание сообщений
  default_scope -> {order('created_at DESC')} 
  #Проверка на валидность
  validates(:content, presence: true, length: {maximum: 140, minimum:3});
  validates(:user_id, presence: true);
end
