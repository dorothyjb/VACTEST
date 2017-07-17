class CreateRmsStatusInfo < ActiveRecord::Migration
  def change
    create_table 'BVADMIN.RMS_STATUS_INFO' do |t|
      t.belongs_to :employee, null: false
      t.string :status_type, limit: 30, null: false
      t.date :rolls_date
      t.date :appointment_onboard_date
      t.string :appointment_notes, limit: 80
      t.string :seperation_status, limit: 30
      t.string :seperation_reason, limit: 30
      t.date :seperation_effective_date
      t.string :temination_notes, limit: 80
      t.date :promotion_date
      t.string :promotion_notes, limit: 80
    end
  end
end
