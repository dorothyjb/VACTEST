class CreateRmsDropDownConfig < ActiveRecord::Migration
  def change
    create_table 'BVADMIN.RMS_DROP_DOWN_CONFIG' do |t|
      t.string :table_id, limit: 30, null: false
      t.string :field_id, limit: 30, null: false
      t.string :content, limit: 45, null: false
      t.string :value, limit: 45, null: false
      t.string :created_by, limit: 60, null: false
    end
  end
end
