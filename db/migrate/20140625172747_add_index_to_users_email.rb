class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
    #Добавление уникального ключа
    add_index(:users, :email, unique: true);
  end
end
