class User < ActiveRecord::Base

	has_many :relationships, foreign_key: "user_id", dependent: :destroy
	has_many :companies, through: :relationships, source: :company, class_name: "Company" 


	before_validation do
		self.token = SecureRandom.hex(8)
	end

	before_save do
		self.email = email.downcase unless email.blank?
	end

	validates_inclusion_of :investor, :in => [true, false]
	validates :token, presence: true


	def following?(company)
		relationships.where("(company_id = ? AND following = ?)", company.id, true)
	end

	def viewed?(company)
		self.companies.include?(company)
	end

	def follow!(company)
		relationships.create!(company_id: company.id, following: true) unless relationships.find_by(company_id: company.id)
	end

	def notfollow!(company)
		relationships.create!(company_id: company.id, following: false) unless relationships.find_by(company_id: company.id)
	end

	def followed_companies
		relationship_list = relationships.where("(user_id = ? AND following = ?)", self.id, true)
		following_companies = []
		puts "rel list" << relationship_list.inspect

		if relationship_list.any?
			relationship_list.each do |rel|
				following_companies.push( Company.find(rel.company_id) )
			end
		end
		return following_companies
	end

	def unviewed_companies
		unviewed_companies = []
		Company.all.each do |comp|
			unviewed_companies.push(comp) unless self.viewed?(comp)
		end
		return unviewed_companies
	end


end

