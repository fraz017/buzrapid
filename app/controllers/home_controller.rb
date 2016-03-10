class HomeController < ApplicationController
	before_action :authenticate_user!
  def index
  end
  def hr
  	@users = User.where('role_cd = 3')
  end
  def add_hr
  	@user = User.new
  end
end
