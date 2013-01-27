class CreateIteStageResults < ActiveRecord::Migration
  def change
    create_table :ite_stage_results do |t|
      t.integer :pos
      t.boolean :dns
      t.boolean :dnf
      t.boolean :dnq
      t.time :time_sec
      t.time :diff_time_sec

      t.timestamps
    end
  end
end
