class CreateEmployeeAwardInfo < ActiveRecord::Migration
  def change
    create_table 'BVADMIN.EMPLOYEE_AWARD_INFO' do |t|
      t.belongs_to :employee, null: false
      t.integer :special_award_amount
      t.date :special_award_date
      t.date :within_grade_date
      t.date :award_date
      t.integer :award_amount
      t.date :quality_step_date
    end
  end
end
