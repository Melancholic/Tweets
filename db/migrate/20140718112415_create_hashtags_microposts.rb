class CreateHashtagsMicroposts < ActiveRecord::Migration
  def change
     create_table :hashtags_microposts, id: false  do |t|
      t.belongs_to :micropost;
      t.belongs_to :hashtag;
    end
  end
end
