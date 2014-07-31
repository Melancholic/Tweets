class AddReplicsUsers < ActiveRecord::Migration
  def change
    create_table :replics_users, id: false  do |t|
      t.belongs_to :user;
      t.belongs_to :micropost;
    end
  end
end
