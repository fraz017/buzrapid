class HomeController < ApplicationController
	before_action :authenticate_user!
  def index
    if current_user.role == :director || current_user.role == :manager || current_user.role == :admin 
      if current_user.role == :admin
        @q = Project.ransack(params[:q])
      elsif current_user.role == :director || current_user.role == :manager
        @q = current_user.company.projects.ransack(params[:q])
      end
      @projects = @q.result.paginate(:page => params[:page], :per_page => 10)
    else
      root_url
    end
  end
  def ongoing_projects
    if current_user.role == :director || current_user.role == :manager || current_user.role == :admin 
      if current_user.role == :admin
        @projects = Project.where("DATE(end_date) > ?", Date.today.to_s).paginate(:page => params[:page], :per_page => 10)
      else
        @projects = current_user.company.projects.where("DATE(end_date) > ?", Date.today.to_s).paginate(:page => params[:page], :per_page => 10)  
      end
    else
      redirect_to root_url
    end
  end
  def completed_projects
    if current_user.role == :director || current_user.role == :manager || current_user.role == :admin 
      if current_user.role == :admin
        @projects = Project.where("DATE(end_date) < ?", Date.today.to_s).paginate(:page => params[:page], :per_page => 10)
      else
        @projects = current_user.company.projects.where("DATE(end_date) < ?", Date.today.to_s).paginate(:page => params[:page], :per_page => 10)  
      end
    else
      redirect_to root_url
    end
  end
  def new_project
    if current_user.role == :director || current_user.role == :manager || current_user.role == :admin
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
          if current_user.role == :admin
            AdminDb.import @project
          else
            ExcelDatum.import @project
          end
        end
        flash[:notice] = "Project successfully added! Some fields might take time.."
        redirect_to home_show_excel_path({:id => @project.id})
      else
        redirect_to home_new_project_path({:errors => @project.errors.messages})
      end
    end
  end
  def show_excel
    if params[:id].present?
      @project = Project.where(:id => params[:id]).last
      if current_user.role == :admin
        if params[:record_id].present?
          @excel = AdminDb.where(:id => params[:record_id]).last
          if @excel.blank?
            @excel = AdminDb.new
          end 
        else
          @excel = AdminDb.new
        end
        @records = @project.admin_dbs.paginate(:page => params[:page], :per_page => 10)
      else
        if params[:record_id].present?
          @excel = ExcelDatum.where(:id => params[:record_id]).last 
          if @excel.blank?
            @excel = ExcelDatum.new
          end 
        else
          @excel = ExcelDatum.new
        end
        @records = @project.excel_datum.paginate(:page => params[:page], :per_page => 10)
      end
    else
      redirect_to root_url
    end
    respond_to do |format|
      format.html
      format.xlsx {
        if current_user.role == :admin
          file_path = AdminDb.generate_excel params[:id]
        else 
          file_path = ExcelDatum.generate_excel params[:id]
        end
        if file_path.present?
          send_file file_path
        end
      }
    end
  end
  def save_record
    if params[:id].present?
      project = Project.where(:id => params[:id]).last
      if project.present?
        if excel_params.present?
          if current_user.role == :admin
            if excel_params[:id].present?
              excel = AdminDb.where(:id => excel_params[:id]).last
              excel.update_attributes(admin_db_params)
            else
              excel = AdminDb.new admin_db_params
            end
          else
            if excel_params[:id].present?
              excel = ExcelDatum.where(:id => excel_params[:id]).last
              excel.update_attributes(excel_params)
            else
              excel = ExcelDatum.new excel_params
            end
          end
          excel.project_id = params[:id]
          if excel.save
            flash[:notice] = "Successfully saved!"
          else
            flash[:notice] = "Something went wrong!"
          end
          redirect_to home_show_excel_path({:id => project.id})
        end
      else
        redirect_to root_url
      end
    else
      redirect_to root_url
    end
  end
  def delete_record
    if params[:id].present?
      if current_user.role == :admin
        record = AdminDb.where(:id => params[:id]).last
      else
        record = ExcelDatum.where(:id => params[:id]).last
      end
      if record.present? and record.destroy
        flash[:notice] = "Successfully Destroyed!"
      else
        flash[:notice] = "Something went wrong!"
      end
      redirect_to request.referer
    else
      redirect_to request.referer  
    end
  end
  def delete_scrap
    if params[:id].present?
      record = ScrapRecord.where(:id => params[:id]).last
      if record.present? and record.destroy
        flash[:notice] = "Successfully Destroyed!"
      else
        flash[:notice] = "Something went wrong!"
      end
      redirect_to request.referer
    else
      redirect_to request.referer  
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
  def market_value
    if params[:id].present?
      if current_user.role == :admin
        @record = AdminDb.where(:id => params[:id]).last
      else
        @record = ExcelDatum.where(:id => params[:id]).last
      end
      if params[:scrap_id].present?
        @scrap = ScrapRecord.where(:id => params[:scrap_id]).last
        if @scrap.blank?
          @scrap = ScrapRecord.new
        end
      else
        @scrap = ScrapRecord.new
      end
      if @record.present?
        @records = ScrapRecord.where("name like ?","%#{@record.com_name.gsub(/\d+/,"")}%")
      end
    else
      redirect_to root_url  
    end
  end
  def update_market_value
    if params[:record_id].present? and params[:value].present?
      if current_user.role == :admin
        record = AdminDb.where(:id => params[:record_id]).last
      else
        record = ExcelDatum.where(:id => params[:record_id]).last
      end
      if record.present?
        scrap = ScrapRecord.where(:id => params[:value]).last
        if scrap.present?
          record.update_attributes(:source => scrap.source, :market_value => scrap.price_pp)
          flash[:notice] = "Successfully Added Market Value!"
        else
          flash[:notice] = "Something went wrong!"  
        end
        redirect_to home_show_excel_path({:id => record.project.id})
      else
        redirect_to root_url
      end
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
  def save_market_value
    if scrap_params.present?
      if params[:scrap_id].present?
        @scrap = ScrapRecord.where(:id => params[:scrap_id]).last
        @scrap.update_attributes(scrap_params)
        flash[:notice] = "Successfully Updated!"
      else
        @scrap = ScrapRecord.new scrap_params
        @scrap.save
        flash[:notice] = "Successfully Added!"
      end
      redirect_to request.referer
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

  def scrap_data
    @scrap = ScrapRecord.new
  end

  def save_scrap_data
    if params[:scrap][:file].present?
      scrap = ScrapRecord.new
      scrap.file = params[:scrap][:file]
      if scrap.save
        ScrapRecord.import(scrap.file)
      end
      flash[:success] = "Successfully Uploaded!"
      redirect_to scrap_data_path
    else
      flash[:warning] = "Something went wrong!"
      redirect_to scrap_data_path
    end
  end

  def update_final_value
    if params[:value].present? && params[:record_id].present?
      if current_user.role == :admin
        record = AdminDb.where(:id => params[:record_id]).last
      else
        record = ExcelDatum.where(:id => params[:record_id]).last
      end
      if record.present?
        record.update_attributes(:final_value => params[:value])
        flash[:success] = "Successfully Assigned!"
      else
        flash[:warning] = "Something went wrong!"
      end
      redirect_to request.referer
    else
      redirect_to request.referer
    end
  end

  private
  def user_params
  	params.require(:user).permit(:id ,:name, :email, :password, :password_confirmation, :role_cd, :company_id)
  end
  def project_params
    params.require(:project).permit(:id ,:name, :bank_name, :end_date, :company_type, :company_id, :appointed_person, :executive, :inflation, :obsolete, :file)
  end
  def excel_params
    params.require(:excel_datum).permit(:id, :com_name, :purchase_date, :market_value, :source, :import_export, :location, :description, :purchase_unit)
  end
  def admin_db_params
    params.require(:admin_db).permit(:id, :com_name, :purchase_date, :market_value, :source, :import_export, :location, :description, :purchase_unit)
  end
  def scrap_params
    params.require(:scrap).permit(:id, :name, :desc, :country, :source, :price_pp, :hs_code)
  end
end
