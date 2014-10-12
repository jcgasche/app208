class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :token
      t.string :name
      t.integer :angel_id
      t.string :angel_token

      t.timestamps
    end
  end
end
