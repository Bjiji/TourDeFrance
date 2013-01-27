class CreateRaceRunners < ActiveRecord::Migration
  def change
    create_table :race_runners do |t|
      t.integer :number
      t.string :nationality
      t.string :team

      t.timestamps
    end
  end
end
