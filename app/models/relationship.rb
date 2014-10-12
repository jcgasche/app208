class Relationship < ActiveRecord::Base
	belongs_to :user, class_name: "User"
	belongs_to :company, class_name: "Company"
end
