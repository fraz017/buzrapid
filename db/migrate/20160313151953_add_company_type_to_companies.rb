class AddCompanyTypeToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :company_type, :string
  end
end
