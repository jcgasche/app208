class AddDetailsToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :logo_url, :text
    add_column :companies, :product_desc, :text
  end
end
