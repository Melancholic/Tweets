class AddRepostIdToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :original_id, :integer
    add_index(:microposts, [:original_id,:content,:user_id], unique: true);
  end
end
