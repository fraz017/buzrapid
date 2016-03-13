class HomeController < ApplicationController
	before_action :authenticate_user!
  def index
    if current_user.role == :admin 
      @q = Project.ransack(params[:q])
      @projects = @q.result.paginate(:page => params[:page], :per_page => 10)
    else
      root_url
    end
  end
  def new_project
    if current_user.role == :admin
      @project = Project.new
      @errors = params[:errors]
    else
      root_url
    end
  end
  def save_project
    if project_params.present?
      @project = Project.new project_params
      if @project.save
        if @project.file_file_size.present?
          begin
            ExcelDatum.import @project 
          rescue
            flash[:notice] = "Something went wrong. Please check the excel file format."
            redirect_to root_url  
          end
        end
        flash[:notice] = "Successfully Added!"
        @project_name = @project.name 
        redirect_to home_show_excel_path({:id => @project.id})
      else
        redirect_to home_new_project_path({:errors => @project.errors.messages})
      end
    end
  end
  def show_excel
    if params[:id].present?
      project = Project.where(:id => params[:id]).last
      if project.present?
        @project_name = project.name
      end
      @records = ExcelDatum.where(:project_id => params[:id]).paginate(:page => params[:page], :per_page => 10)
    else
      redirect_to root_url
    end
  end
  def edit_project
    if params[:id].present?
      @project = Project.where(:id => params[:id]).last
      if @project.blank?
        redirect_to root_url
      end
      @errors = params[:errors]
    else
      redirect_to root_url
    end
  end

  def update_project
    if project_params.present? and params[:id]
      @project = Project.find params[:id]
      if @project.present? && @project.update_attributes(project_params)
        flash[:notice] = "Successfully Updated!"
        redirect_to root_url
      else
        redirect_to home_edit_project_path({:errors => @project.errors.messages, :id => @project.id})
      end
    else
      redirect_to root_url  
    end
  end

  def employees
  	if current_user.role == :hr || current_user.role == :director
  		@users = current_user.company.users.where('role_cd != 3 and role_cd != 4')
  	else
  		redirect_to root_url
  	end
  end
  def hr
  	@users = User.where('role_cd = 3')
  end
  def add_hr
  	@user = User.new(:role_cd => 3)
  	@errors = params[:errors]
  end
  def add_user
  	@user = User.new
  	@errors = params[:errors]
  end
  def save_user
  	if user_params.present?
  		@user =  User.new user_params
  		if params[:company].present?	
  			@user.company_id = params[:company][:name] 
  		else
  			@user.company_id = current_user.company_id	
  		end
  		if @user.save
  			flash[:notice] = "User Successfully Created!"
  			if current_user.role == :admin 
  			  redirect_to hr_path
  			else
  				redirect_to employees_path
  			end
  		else
  			if current_user.role == :admin 
  			  redirect_to home_add_hr_path({:errors => @user.errors.messages})
  			else
  				redirect_to home_add_user_path({:errors => @user.errors.messages})
  			end
  		end
  	else
  		redirect_to root_url
  	end
  end

  def delete_project
    if params[:id].present?
      project = Project.where(:id => params[:id]).last
      if project.destroy
        flash[:notice] = "Successfully Destroyed!"
        redirect_to root_url
      else
        flash[:notice] = "Something went wrong!"
        redirect_to root_url
      end
    else
      redirect_to root_url
    end
  end

  def delete_user
  	if params[:id].present?
  		user = User.where(:id => params[:id]).last
  		if user.destroy
  			flash[:notice] = "Successfully Destroyed!"
  			if current_user.role == :admin 
  			  redirect_to hr_path
  			else
  				redirect_to employees_path
  			end
  		else
  			flash[:notice] = "Something went wrong!"
  			if current_user.role == :admin 
  			  redirect_to hr_path
  			else
  				redirect_to employees_path
  			end
  		end
    else
      redirect_to root_url  
  	end
  end

  def edit_user
  	if params[:id].present?
  		@user = User.where(:id => params[:id]).last
  		if @user.blank?
  			if current_user.role == :admin 
  			  redirect_to hr_path
  			else
  				redirect_to employees_path
  			end
  		end
  		@errors = params[:errors]
  	else
  		if current_user.role == :admin 
			  redirect_to hr_path
			else
				redirect_to employees_path
			end
  	end
  end

  def update_user
  	if user_params.present? and params[:id]
  		@user = User.find params[:id]
  		if @user.present? && @user.update_attributes(user_params)
  			if params[:company].present?
  				@user.company_id = params[:company][:name]
  			else
  				@user.company_id = current_user.company_id
  			end
  			@user.save
  			flash[:notice] = "Successfully Updated!"
  			if current_user.role == :admin 
  			  redirect_to hr_path
  			else
  				redirect_to employees_path
  			end
  		else
  			redirect_to home_edit_user_path({:errors => @user.errors.messages, :id => @user.id})
  		end
  	end
  end

  private
  def user_params
  	params.require(:user).permit(:id ,:name, :email, :password, :password_confirmation, :role_cd)
  end
  def project_params
    params.require(:project).permit(:id ,:name, :bank_name, :end_date, :company_type, :company_id, :appointed_person, :executive, :inflation, :obsolete, :file)
  end
end
