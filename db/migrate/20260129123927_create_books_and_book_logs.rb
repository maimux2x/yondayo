class CreateBooksAndBookLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :book_logs do |t|
      t.references :user, null: false, foreign_key: true

      t.integer :status, default: 0,  null: false
      t.string  :comment

      t.timestamps
    end

    create_table :books do |t|
      t.references :book_log, foreign_key: true

      t.string :title,     null: false
      t.string :author,    null: false
      t.string :publisher
      t.date   :published_at

      t.timestamps
    end
  end
end
