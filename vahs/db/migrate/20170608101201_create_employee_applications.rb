class CreateEmployeeApplications < ActiveRecord::Migration
  def change
    create_table 'BVADMIN.EMPLOYEE_APPLICATIONS', primary_key: :application_id do |t|
      t.index :application_id

      t.integer :applicant_id, index: true, null: false
      t.string :status, limit: 30, index: true, null: false
      t.string :org_code, limit: 25
      t.string :vaccancy_number, limit: 12, index: true
      t.string :title, limit: 30

      t.date :process_start_date
      
      t.date :selected_date
      t.date :tentative_offer_date
      t.date :sent_to_security_date
      t.date :final_offer_date
      t.date :requested_eod
      t.date :confirmed_eod

      t.integer :org_information_id, index: true, null: false
      t.string :comments

      t.date :effective_date
    end
  end
end
