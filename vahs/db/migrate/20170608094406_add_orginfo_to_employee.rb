class AddOrginfoToEmployee < ActiveRecord::Migration
  def change
    add_column 'BVADMIN.EMPLOYEE', :org_code, :string, limit: 25
    add_column 'BVADMIN.EMPLOYEE', :org_information_id, :integer
  end
end
