class AddPobAndMsbToEmployee < ActiveRecord::Migration
  def change
    add_column 'BVADMIN.EMPLOYEE', :pob_city, :string, limit: 35
    add_column 'BVADMIN.EMPLOYEE', :pob_state, :string, limit: 2
    add_column 'BVADMIN.EMPLOYEE', :pob_country, :string, limit: 40
    add_column 'BVADMIN.EMPLOYEE', :military_service_branch, :string, limit: 20
  end
end
