module HomeHelper
	def username(id)
		user = User.where(:id => id).last
		if user.present?
			return user.name
		else
			return ""
		end
	end
end
