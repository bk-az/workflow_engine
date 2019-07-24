class ChangeDomainToSubdomainInCompany < ActiveRecord::Migration
  def change
    rename_column :companies, :domain_name, :subdomain
  end
end
