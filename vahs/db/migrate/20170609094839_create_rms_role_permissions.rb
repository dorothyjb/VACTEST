class CreateRmsRolePermissions < ActiveRecord::Migration
  def change
    create_table 'BVADMIN.RMS_ROLE_PERMISSIONS', primary_key: :permission_id do |t|
      t.index :permission_id

      t.integer :role_id, null: false, index: true
      t.string :table_name, null: false, index: true, limit: 100
      t.string :field_name, null: false, index: true, limit: 100
      t.boolean :read_access, default: true
      t.boolean :write_access, default: false
    end
  end
end
