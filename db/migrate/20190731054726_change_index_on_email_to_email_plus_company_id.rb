class ChangeIndexOnEmailToEmailPlusCompanyId < ActiveRecord::Migration
  def change
    # Remove this line
    remove_index :users, column: :email, unique: true

    # Replace with
    add_index :users, [:email, :company_id], unique: true
  end
end
