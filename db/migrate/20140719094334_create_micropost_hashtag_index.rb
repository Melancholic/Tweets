class CreateMicropostHashtagIndex < ActiveRecord::Migration
  def change
    add_index(:hashtags_microposts, [:micropost_id,:hashtag_id], unique: true);
  end
end
