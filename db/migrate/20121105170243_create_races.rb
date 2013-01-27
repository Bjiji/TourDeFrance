class CreateRaces < ActiveRecord::Migration
  def change
    create_table :races do |t|
      t.string :name
      t.string :year
      t.integer :distance
      t.float :averageSpeed
      t.int :winnerPrize
      t.integer :poolPrize
      t.string :description

      t.timestamps
    end
  end
end
