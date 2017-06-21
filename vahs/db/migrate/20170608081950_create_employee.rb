class CreateEmployee < ActiveRecord::Migration
  def change
    create_table 'BVADMIN.EMPLOYEE', primary_key: :employee_id do |t|
      t.index :employee_id

      t.string :attorney_id, limit: 4
      t.string :user_id, limit: 6
      t.string :login_id, limit: 10

      t.string :lname, limit: 30
      t.string :fname, limit: 17
      t.string :mi, limit: 1
      t.string :name, limit: 60
      t.string :sub_title, limit: 9
      t.string :fname2, limit: 17
      t.string :prev_lname, limit: 30

      t.string :pay_sched, limit: 7
      t.string :grade, limit: 5
      t.string :step, limit: 2

      t.integer :salary
      t.integer :fte

      t.string :service, limit: 3
      t.string :work_group, limit: 15
      t.string :route_sym, limit: 9
      t.string :barg_client, limit: 4
      t.string :flsa, limit: 1
      
      t.string :appt_type, limit: 2
      t.string :cost_center, limit: 9

      t.date :date_of_grade
      t.date :date_of_birth
      t.integer :age

      t.string :time_leave_unit, limit: 4
      t.date :current_bva_duty_date
      t.date :prior_bva_duty_date
      t.date :co_duty_date
      t.date :assgnmt_date
      t.date :promo_elig_date
      t.date :srvce_comp_date
      t.integer :years_of_srvce

      t.string :gender, limit: 1
      t.string :vet_status, limit: 1
      t.string :bva_title, limit: 30
      t.string :paid_title, limit: 30
      t.string :job_code, limit: 4
      t.string :job_status, limit: 1
      t.string :roll_call, limit: 3

      t.string :street, limit: 40
      t.string :city, limit: 20
      t.string :state, limit: 2
      t.string :zip, limit: 9
      t.string :home_phone, limit: 14
      t.string :work_phone, limit: 14
      t.string :fax, limit: 14
      t.string :pager, limit: 14

      t.string :poc_name, limit: 30
      t.string :poc_relation, limit: 15
      t.string :poc_street, limit: 30
      t.string :poc_city, limit: 15
      t.string :poc_state, limit: 2
      t.string :poc_zip, limit: 10
      t.string :poc_work_phone, limit: 14
      t.string :poc_home_phone, limit: 14
      t.string :poc_notes, limit: 80

      t.string :blding_room, limit: 10
      t.string :position_num, limit: 8
      t.string :position_detail, limit: 10
      
      t.integer :duty_status

      t.date :pms_from_date
      t.date :pms_to_date
      t.string :prev_pms3, limit: 2
      t.string :prev_pms2, limit: 2
      t.string :prev_pms, limit: 2
      t.string :current_pms, limit: 2

      t.integer :award_amt
      t.date :award_date

      t.date :qsi_date

      t.integer :spec_award_amt
      t.date :spec_award_date

      t.date :wig_date

      t.string :employment_status, limit: 15
      t.date :status_change_date
      t.string :employment_status2, limit: 15
      t.date :status_change_date2

      t.string :retire_cert, limit: 6

      t.string :ssn, limit: 11

      t.string :eom, limit: 20
      t.string :the_4652_num, limit: 8

      t.string :action_type, limit: 20
      t.date :action_date

      t.string :comp_wk_sched, limit: 2

      t.string :mon1, limit: 9
      t.string :tues1, limit: 9
      t.string :wed1, limit: 9
      t.string :thur1, limit: 9
      t.string :fri1, limit: 9
      t.string :mon2, limit: 9
      t.string :tues2, limit: 9
      t.string :wed2, limit: 9
      t.string :thur2, limit: 9
      t.string :fri2, limit: 9

      t.string :bar_member, limit: 12
      t.string :supervisor, limit: 6
      t.string :disc_action, limit: 240
      t.string :optiona, limit: 9
      t.integer :optionb
      t.string :vendor_code, limit: 15
      t.string :pc_serial, limit: 20
      t.string :sec_level, limit: 1

      t.string :veteran_preference, limit: 30
      t.string :retired_military, limit: 30
      
      t.date :upward_mobility_eff_date

      t.string :fegli, limit: 30
      t.string :retirement_system, limit: 30
      t.string :fehb, limit: 30

      t.date :last_salary_change_date
      t.date :load_date
      t.date :bva_update_date

      t.integer :bvabais_sec_level
      t.string :monitor_serial, limit: 20
      t.string :flexiplace, limit: 1
      t.date :last_wig_date
      t.string :emploc_view, limit: 1
      t.string :ein, limit: 12
      t.string :hrsmart_id, limit: 8
    end
  end
end
