class CreateProperties < ActiveRecord::Migration[6.0]
  def change
    create_table :properties do |t|
      t.string     :content, null: false
      t.references :user,   foreign_key: true

      t.timestamps
    end
  end
end
