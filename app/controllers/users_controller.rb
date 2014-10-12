class UsersController < ApplicationController
	skip_before_filter :verify_authenticity_token

	APP208_ANGELCO_CLIENT_ID = '88382b671bafbc2f58f8d6cc75a2ddb2'
	APP208_ANGELCO_CLIENT_TOKEN = '125bcdfa25cd0c6d82e4ce4988334e9a'
	APP208_ANGELCO_CLIENT_SECRET = '1c002227a66cc1147eca0f025e3138bc'

	#redirect from:
	#https://angel.co/api/oauth/authorize?client_id=88382b671bafbc2f58f8d6cc75a2ddb2&scope=message%20email%20comment%20talent&response_type=code
	def login_angelco
		@response = {errors: []}
		

		if params[:code].blank?

			#now get info about the user
			url = URI.parse("http://www.payonesnap.com/app208_angel_login/#{params[:code]}")
			req = Net::HTTP::Get.new(url.to_s)
			response = Net::HTTP.start(url.host, url.port) {|http|
				http.request(req)
			}
			response_hash = JSON.parse response.body

			puts response_hash.inspect

			user = User.find_by_angel_id(response_hash["id"]) unless response_hash["id"].blank?
				

			if user
				#user already exists, update token and return its logins (id and email)
				user.token = access_token
				user.investor = response_hash["investor"] == 'true'
				@response[:id] = user.id
				@response[:investor] = user.investor?.to_s
				@response[:status] = "success"
				

			else
				#create a new user, return the logins (id and email)
				user = User.new(angel_id: response_hash["id"], token: access_token, name: response_hash["name"])
				user.investor = response_hash["investor"] == 'true'
				
				if user.save
					@response[:id] = user.id
					@response[:investor] = user.investor?.to_s
					@response[:status]= "success"
				else
					@response[:status]= "unsure"
				end
			end
			
		else
			user = User.new(angel_id: params[:code], token: params[:token], name: "Amaury Soviche")
			user.investor = 'true'
				
			if user.save
				@response[:id] = user.id
				@response[:investor] = user.investor?.to_s
				@response[:status]= "success"
			else
				@response[:status]= "unsure"
			end

			#@response[:status]= "failure"
			#@response[:errors].push("noCodeReceived")
		end

		render xml: @response
	end




	def login_email
		@response = {errors: []}

		unless params[:email].blank?

			user = User.find_by_email(params[:email])

			if user
				#user already exists, update angel_token and return its logins (id)
				@response[:id] = user.id
				@response[:investor] = "false"
				@response[:status] = "success"

			else
				#create a new user, return the logins (id)
				user = User.new(email: params[:email])
				user.investor = false

				if user.save
					@response[:id] = user.id
					@response[:investor] = user.investor?.to_s
					@response[:status]= "success"
				else
					@response[:status]= "failure"
				end
			end
			
		else
			@response[:status]= "failure"
			@response[:errors].push("invalidCredentials")
		end

		render xml: @response
	end




	def show
		@response = {errors: [], companies: []}
		user = User.find(params[:user_id])

		user.unviewed_companies[0..9].each do |unviewed_company|
			company = {name: unviewed_company.name, id: unviewed_company.id, 
				logo_url: unviewed_company.logo_url, product_desc: unviewed_company.product_desc,
				markets: unviewed_company.markets,
				raising_amount: unviewed_company.raising_amount, 
				pre_money_valuation: unviewed_company.pre_money_valuation}

			@response[:companies].push(company)
		end

		render xml: @response
	end


	def follow_company
		@response = {errors: []}
		company = Company.find(params[:company_id])
		user = User.find(params[:user_id])
		user.follow!(company)
		@response[:status] = "success"
		@response[:company_id] = params[:company_id]
		@response[:user_id] = params[:user_id]
		render xml: @response
	end

	def notfollow_company
		@response = {errors: []}
		company = Company.find(params[:company_id])
		user = User.find(params[:user_id])
		user.notfollow!(company)
		@response[:status] = "success"
		@response[:company_id] = params[:company_id]
		@response[:user_id] = params[:user_id]
		render xml: @response
	end


	def followed_companies
		@response = {errors: [], companies: []}
		user = User.find(params[:user_id])

		user.followed_companies.each do |followed_company|
			company = {name: followed_company.name, id: followed_company.id, 
				logo_url: followed_company.logo_url, product_desc: followed_company.product_desc}
			@response[:companies].push(company)
		end

		@response[:status] = "success"
		@response[:user_id] = params[:user_id]
		render xml: @response
	end


	def display_company
		@response = {errors: [], followers: []}
		company = Company.find(params[:company_id])
		user = User.find(params[:user_id])

		if user.investor? && user.following?(company)
			@response[:followers] = company.investor_followers
		end

		@response[:users_following] = company.followers.count
		@response[:total_views] = company.viewers.count


		@response[:status] = "success"
		@response[:user_id] = params[:user_id]
		render xml: @response
	end





end







