class CreateReadings < ActiveRecord::Migration[8.1]
  def change
    create_table :readings do |t|
      t.references :book, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false

      t.integer :status, null: false, default: 0
      t.string  :comment

      t.timestamps

      t.index %i[book_id user_id], unique: true
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL
          INSERT INTO readings (book_id, user_id, status, comment, created_at, updated_at)
          SELECT id, user_id, status, comment, TIME('now'), TIME('now')
          FROM books
        SQL
      end
    end

    remove_reference :books, :user, foreign_key: true, null: false

    remove_column :books, :status, null: false, default: 0
    remove_column :books, :comment
  end
end
