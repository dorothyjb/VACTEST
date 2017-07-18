class CreatePayperiods < ActiveRecord::Migration
  def change
    create_table 'BVADMIN.PAYPERIODS', id: false do |t|
      t.integer :payperiod, null: false
      t.date :startdate
      t.date :enddate
    end
  end
end
