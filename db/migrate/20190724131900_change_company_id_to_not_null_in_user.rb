class ChangeCompanyIdToNotNullInUser < ActiveRecord::Migration
  def change
    change_column_null :users, :company_id, null: false
  end
end
