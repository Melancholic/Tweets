class CreateResetPasswords < ActiveRecord::Migration
  def change
    create_table :reset_passwords do |t|
   #   t.integer :user_id,  null: false
      t.belongs_to :user, index: true
      t.string :password_key, null: false
      t.string :host

      t.timestamps
    end
  end
end
