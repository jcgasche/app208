class UsersController < ApplicationController
	skip_before_filter :verify_authenticity_token
	before_action :correct_user,   except: [ :login_angelco, :login_email ]

	APP208_ANGELCO_CLIENT_ID = '88382b671bafbc2f58f8d6cc75a2ddb2'
	APP208_ANGELCO_CLIENT_TOKEN = '125bcdfa25cd0c6d82e4ce4988334e9a'
	APP208_ANGELCO_CLIENT_SECRET = '1c002227a66cc1147eca0f025e3138bc'

	#redirect from:
	#https://angel.co/api/oauth/authorize?client_id=88382b671bafbc2f58f8d6cc75a2ddb2&scope=message%20email%20comment%20talent&response_type=code
	def login_angelco
		@response = {errors: []}
		

		if params[:code].present? && params[:error] != "access_denied"


			uri = "https://angel.co/api/oauth/token?client_id=88382b671bafbc2f58f8d6cc75a2ddb2&client_secret=1c002227a66cc1147eca0f025e3138bc&code=#{params[:code]}&grant_type=authorization_code"
			uri = URI.parse(uri)
			response = Net::HTTP.post_form(uri, {})

			puts response.body.inspect
			#now that request has been issued, parse request to get access token
			response_hash = JSON.parse response.body

			puts response_hash.inspect

			access_token = response_hash["access_token"]

			puts access_token

			res = Net::HTTP.get_response(URI("https://api.angel.co/1/me?access_token=#{access_token}"))
			puts res.body if res.is_a?(Net::HTTPSuccess)

			response_hash = JSON.parse res.body
			user = User.find_by_angel_id(response_hash["id"]) unless response_hash["id"].blank?


			if user
				#user already exists, update token and return its logins (id and email)
				is_investor = response_hash["investor"] == 'true'
				email = response_hash["email"]
				if user.update_attributes(angel_token: access_token, investor: is_investor, email: email)
					@response[:id] = user.id
					@response[:token] = user.token
					@response[:investor] = user.investor?.to_s
					@response[:status]= "success"
				else
					@response[:id] = user.id
					@response[:investor] = user.investor?.to_s
					@response[:token] = user.token
					@response[:status]= "unsure"
				end
				
			elsif access_token.present? && response_hash["id"].present?
				#create a new user, return the logins (id and email)
				user = User.new(angel_id: response_hash["id"], 
					angel_token: access_token, name: response_hash["name"],
					)
				user.investor = response_hash["investor"] == 'true'
				user.email = response_hash["email"]

				if user.save
					@response[:id] = user.id
					@response[:token] = user.token
					@response[:investor] = user.investor?.to_s
					@response[:status]= "success"
				else
					@response[:status]= "unsure"
				end
			else
				@response[:status]= "unsure"
			end
			
		else
			@response[:status]= "failure"
			@response[:errors].push("accessDenied")
			@response[:errors].push("noCodeReceived")
		end

		render xml: @response
	end




	def login_email
		@response = {errors: []}

		unless params[:email].blank?

			user = User.find_by_email(params[:email])

			if user

				@response[:id] = user.id
				@response[:token] = user.token
				@response[:investor] = user.investor?.to_s
				@response[:status] = "success"

			else
				#create a new user, return the logins (id)
				user = User.new(email: params[:email])

				if user.save
					@response[:id] = user.id
					@response[:token] = user.token
					@response[:investor] = user.investor?.to_s
					@response[:status]= "success"
				else
					@response[:errors].push("validationFailed")
					@response[:status]= "failure"
				end
			end
			
		else
			@response[:status]= "failure"
			@response[:errors].push("emailMissing")
		end

		render xml: @response
	end



	def login_twitter
		@response = {errors: []}

		unless params[:twitter_id].blank?

			user = User.find_by_twitter_id(params[:twitter_id])

			if user

				@response[:id] = user.id
				@response[:token] = user.token
				@response[:investor] = user.investor?.to_s
				@response[:status] = "success"

			else
				#create a new user, return the logins (id)
				user = User.new(twitter_id: params[:twitter_id])
				user.investor = false

				if user.save
					@response[:id] = user.id
					@response[:token] = user.token
					@response[:investor] = user.investor?.to_s
					@response[:status]= "success"
				else
					@response[:errors].push("validationFailed")
					@response[:status]= "failure"
				end
			end
			
		else
			@response[:status]= "failure"
			@response[:errors].push("emailMissing")
		end

		render xml: @response
	end

					

	def show
		@response = {errors: [], companies: []}
		User.find(params[:user_id]).unviewed_companies[0..9].each { |company| @response[:companies].push(company.info) }
		if @response.empty?
			@response[:status] = "failure"
		else
			@response[:status] = "success"
		end

		render xml: @response
	end


	def follow_company
		
		company = Company.find(params[:company_id])
		user = User.find(params[:user_id])

		@response = {errors: []}
		
		unless user.viewed?(company)
			user.follow!(company) 
			@response[:status] = "success"
		else
			@response[:status] = "failure"
			@response[:errors].push('alreadySwipedCompany')
		end

		render xml: @response
	end



	def notfollow_company
		
		company = Company.find(params[:company_id])
		user = User.find(params[:user_id])

		@response = {errors: []}

		unless user.viewed?(company)
			user.notfollow!(company) 
			@response[:status] = "success"
		else
			@response[:status] = "failure"
			@response[:errors].push('alreadySwipedCompany')
		end
		
		render xml: @response
	end


	def followed_companies
		
		user = User.find(params[:user_id])

		@response = {errors: [], companies: []}

		user.followed_companies.each do |company|
			@response[:companies].push(company.info)
		end

		@response[:status] = "success"
		@response[:user_id] = params[:user_id]
		render xml: @response
	end


	def display_company
		
		company = Company.find(params[:company_id])
		user = User.find(params[:user_id])

		@response = { errors: [], investor_followers: [], company: company.info }

		if user.investor? && user.following?(company)
			company.investor_followers.each do |investor|
				@response[:investor_followers].push( investor.name ) unless investor.name.blank?

				#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				@response[:investor_followers].push( "Blanco Bernasconi" ) if investor.name.blank?
			end
		end

		@response[:status] = "success"
		render xml: @response
	end



	private

		def correct_user
			user = User.find_by(id: params[:user_id])
			unless user.blank? || user.token == params[:token]
				@response = {errors: ["invalidCredentials"], status: "failure"}
				render xml: @response
			end
		end


end







