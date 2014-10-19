class Relationship < ActiveRecord::Base
	belongs_to :user, class_name: "User"
	belongs_to :company, class_name: "Company"
	validates :user_id, presence: true
  	validates :company_id, presence: true
end
