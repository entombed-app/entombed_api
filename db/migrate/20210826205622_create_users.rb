class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :password_digest
      t.string :email
      t.string :name
      t.date :date_of_birth
      t.string :profile_picture
      t.text :obituary

      t.timestamps
    end
  end
end
