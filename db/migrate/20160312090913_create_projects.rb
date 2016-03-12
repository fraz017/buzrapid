class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :bank_name
      t.date :end_date
      t.string :company_type
      t.integer :company_id
      t.integer :appointed_person
      t.integer :executive
      t.string :inflation
      t.string :obsolete

      t.timestamps null: false
    end
  end
end
