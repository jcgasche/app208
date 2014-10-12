class CompaniesController < ApplicationController

	def fill_db

		# Get companies raising - from AngelCo API
		url = URI.parse("https://api.angel.co/1//startups?filter=raising")
		req = Net::HTTP::Get.new(url.to_s)
		response = Net::HTTP.start(url.host, url.port) {|http|
			http.request(req)
		}

		# Response hash contains startup info (id, name, fundraising),
		response_hash = JSON.parse response.body

		companies = response_hash['startups']


		# Take each company individually and create company in database 
		companies.each do |company| 
			unless Company.find_by(angel_id: company['id'])
				Company.new(angel_id: company['id'], name: company['name']).save!
			end
		end

	end

end
