class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.integer    :status,   default: 0, null: false
      t.references :property, foreign_key: true

      t.timestamps
    end
  end
end
