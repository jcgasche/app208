module CompaniesHelper


		def companies_to_load?( page, last_page, limit)

			unless limit.nil?
				if (page <= last_page && Company.count < limit.to_i)
					puts "_____________________________"
					puts "_____________________________"
					puts "_____________________________"
					puts "_____________________________"
					puts "true"
					puts "count: #{Company.count}"
					puts "limit: #{limit.to_i}"
					return true
				else
					return false
					puts "false"
				end
			else
				return false
			end

		end


end
