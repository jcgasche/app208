class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.integer :angel_id
      t.string :name

      t.timestamps
    end
  end
end
