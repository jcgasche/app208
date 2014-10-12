class User < ActiveRecord::Base

	has_many :relationships, dependent: :destroy
	has_many :viewed_companies, through: :relationships, source: :company_id, class_name: "Company" 

	before_save do
		self.email = email.downcase unless email.blank?
	end

	validates_inclusion_of :investor, :in => [true, false]




	def following?(company)
		relationships.where("(company_id = ? AND following = ?)", company.id, true)
	end

	def viewed?(company)
		relationships.where("(company_id = ?)", company.id).nil?
	end

	def follow!(company)
		relationships.create!(company_id: company.id, following: true) unless relationships.find_by(company_id: company.id)
	end

	def notfollow!(company)
		relationships.create!(company_id: company.id, following: false) unless relationships.find_by(company_id: company.id)
	end

	def followed_companies
		relationship_list = relationships.where("(user_id = ? AND following = ?)", self.id, true)

		relationship_list.each do |rel|
			following_companies = viewed_companies.where("(id = ?)", rel.company_id)
		end
		return following_companies
	end

	def unviewed_companies
		unviewed_companies = []
		Company.all.each do |comp|
			unviewed_companies.push(comp) unless viewed?(comp)
		end
		return unviewed_companies
	end


end

