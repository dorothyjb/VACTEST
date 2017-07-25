class CreateRmsEmployeeAssignmentInfo < ActiveRecord::Migration
  def change
    create_table 'BVADMIN.RMS_EMPLOYEE_ASSIGNMENT_INFO' do |t|
      t.belongs_to :employee, null: false
      t.string :assignment_type, null: false, limit: 30
      t.string :telework_street, limit: 30
      t.string :telework_city, limit: 30
      t.string :telework_state, limit: 30
      t.string :telework_zip, limit: 30
      t.string :room_number, limit: 30
      t.string :other_assignment, limit: 30
      t.date :effective_date
      t.string :location_detailed, limit: 30
      t.date :expected_return_date
      t.string :leave_period, limit: 30
      t.string :leave_contact_info, limit: 30
      t.string :telework_type, limit: 30
      t.string :reason_for_leave, limit: 80
      t.string :loc_m1, limit: 5
      t.string :loc_m2, limit: 5
      t.string :loc_tu1, limit: 5
      t.string :loc_tu2, limit: 5
      t.string :loc_w1, limit: 5
      t.string :loc_w2, limit: 5
      t.string :loc_th1, limit: 5
      t.string :loc_th2, limit: 5
      t.string :loc_f1, limit: 5
      t.string :loc_f2, limit: 5
      t.string :primary_station, limit: 80
      t.string :satellite_station, limit: 80
      t.string :satellite_room, limit: 12
    end
  end
end
