class AddRaisedAmountToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :raised_amount, :string
  end
end
