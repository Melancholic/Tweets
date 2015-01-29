class AddRepostIdToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :repost_id, :integer
    add_index(:microposts, [:repost_id,:content,:user_id], unique: true);
  end
end
