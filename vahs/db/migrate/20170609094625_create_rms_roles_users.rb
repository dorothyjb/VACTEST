class CreateRmsRolesUsers < ActiveRecord::Migration
  def change
    create_table 'BVADMIN.RMS_ROLES_USERS' do |t|
      t.integer :user_id, null: false, index: true
      t.integer :role_id, null: false, index: true
    end
  end
end
