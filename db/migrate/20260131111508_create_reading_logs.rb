class CreateReadingLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :reading_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true

      t.integer :status, default: 0,  null: false
      t.string  :comment

      t.timestamps
    end
  end
end
