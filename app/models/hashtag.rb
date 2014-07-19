class Hashtag < ActiveRecord::Base
   #Static method
  def self.get_regex
    return /[#][a-zA-Zа-яА-Я0-9\_]+/;
  end 
  
  has_and_belongs_to_many :micropost;
  LengthText=25;
  validates(:text, presence: true,length: {maximum: LengthText},format: {with:  /[a-zA-Zа-яА-Я0-9\_]+/});
  default_scope -> {order('text ASC')}   

  before_save{
    self.text=self.text.downcase;
  }
  
  def full_text
    '#'+self.text
  end

  def get_uniq_microposts
    self.micropost.uniq{|t| t.id}
  end

end
