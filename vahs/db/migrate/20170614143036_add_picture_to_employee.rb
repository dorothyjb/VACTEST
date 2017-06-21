class AddPictureToEmployee < ActiveRecord::Migration
  def change
    add_column 'BVADMIN.EMPLOYEE', :picture_data, :blob, limit: 5 * 1024 * 1024
    add_column 'BVADMIN.EMPLOYEE', :picture_mime, :string, limit: 40
  end
end
