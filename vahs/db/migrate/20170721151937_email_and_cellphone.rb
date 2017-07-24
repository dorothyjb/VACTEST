class EmailAndCellphone < ActiveRecord::Migration
  def change
    add_column 'BVADMIN.EMPLOYEE', :cell_phone, :string, limit: 14
    add_column 'BVADMIN.EMPLOYEE', :poc_cell_phone, :string, limit: 14
    add_column 'BVADMIN.EMPLOYEE', :email_address, :string, limit: 40
    add_column 'BVADMIN.EMPLOYEE', :poc_email_address, :string, limit: 40
  end
end
