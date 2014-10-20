class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
    	t.integer :company_id
    	t.integer :user_id
    	t.boolean :following
      t.timestamps
    end
  end
end
