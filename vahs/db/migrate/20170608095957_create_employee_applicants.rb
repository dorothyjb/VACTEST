class CreateEmployeeApplicants < ActiveRecord::Migration
  def change
    create_table 'BVADMIN.EMPLOYEE_APPLICANTS', primary_key: :applicant_id do |t|
      t.index :applicant_id

      t.string :fname, limit: 17, null: false
      t.string :lname, limit: 30, null: false
      t.string :name, limit: 60
      t.date :date_of_birth
      t.string :series, limit: 4  # JOB_CODE
      t.string :grade, limit: 5
      t.string :pay_plan, limit: 7 # PAY_SCHED?

      t.integer :employee_id, index: true, default: nil
    end
  end
end
