class Organization < ActiveRecord::Migration
  def change
    create_table 'BVADMIN.RMS_ORG_INFORMATION' do |t|
      t.string :type, limit: 40
      t.string :name, limit: 50
    end

    create_table 'BVADMIN.RMS_ORG_CODE' do |t|
      t.integer :office_id, index: true
      t.integer :division_id, index: true
      t.integer :branch_id, index: true
      t.integer :unit_id, index: true
      t.string :code, index: true, limit: 45, null: false
      t.belongs_to :employee, index: true
      t.integer :rotation, default: 0
    end

    add_column 'BVADMIN.EMPLOYEE', :rotation_start, :date
    add_column 'BVADMIN.EMPLOYEE', :rotation_end, :date
  end
end
