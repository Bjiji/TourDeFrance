class CreateStages < ActiveRecord::Migration
  def change
    create_table :stages do |t|
      t.string :date
      t.string :start
      t.string :finish
      t.string :stageNb
      t.string :subStageNb
      t.string :stage_type
      t.string :year
      t.string :runners_cnt
      t.string :finisher_cnt
      t.string :distance
      t.string :label

      t.timestamps
    end
  end
end
