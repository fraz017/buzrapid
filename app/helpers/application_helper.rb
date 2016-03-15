module ApplicationHelper
	def management?
		if current_user.role == :admin || current_user.role == :director || current_user.role == :manager 
			return true
		else
			return false
		end
	end
end
