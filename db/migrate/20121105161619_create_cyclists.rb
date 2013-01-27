class CreateCyclists < ActiveRecord::Migration
  def change
    create_table :cyclists do |t|
      t.string :firstname
      t.string :lastname
      t.date :dob
      t.string :pob
      t.string :nationality
      t.string :description

      t.timestamps
    end
  end
end
