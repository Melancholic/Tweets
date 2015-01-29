class CreateReposts < ActiveRecord::Migration
  def change
    create_table :reposts do |t|
      t.integer :user_id
      t.integer :micropost_id
     # t.timestamps
    end
    add_index(:reposts, :user_id);
    add_index(:reposts, :micropost_id);
    add_index(:reposts, [:user_id,:micropost_id], unique: true);
  end
end
