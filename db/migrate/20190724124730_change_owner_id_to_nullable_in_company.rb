class ChangeOwnerIdToNullableInCompany < ActiveRecord::Migration
  def change
    change_column_null :companies, :owner_id, null: true
  end
end
