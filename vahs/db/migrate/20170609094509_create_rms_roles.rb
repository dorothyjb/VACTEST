class CreateRmsRoles < ActiveRecord::Migration
  def change
    create_table 'BVADMIN.RMS_ROLES', primary_key: :role_id do |t|
      t.index :role_id

      t.string :name, limit: 60, index: true, null: false
    end
  end
end
