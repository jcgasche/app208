class AddMarketToCompany < ActiveRecord::Migration
  def change
  	add_column :companies, :high_concept, :text
    add_column :companies, :markets, :text
    add_column :companies, :raising_amount, :string
    add_column :companies, :pre_money_valuation, :string
  end
end
