class CreateAttorney < ActiveRecord::Migration
  def change
    create_table 'BVADMIN.ATTORNEY', id: false do |t|
      t.string :attorney_id, limit: 4, null: false, index: true
      t.belongs_to :employee, index: true
      t.string :bar_member, limit: 12
      t.date :board_appt_date
      t.date :board_exp_date
      t.date :board_reappt_date
      t.text :notes, limit: 600
      t.string :license, limit: 60
      t.string :jurisdiction, limit: 60
      t.string :lawschool, limit: 60
      t.text :attorney_notes, limit: 600
    end
  end
end
