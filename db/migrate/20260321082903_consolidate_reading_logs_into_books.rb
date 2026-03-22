class ConsolidateReadingLogsIntoBooks < ActiveRecord::Migration[8.1]
  def up
    add_reference :books, :user,    foreign_key: true
    add_column    :books, :status,  :integer, default: 0
    add_column    :books, :comment, :string

    execute <<~SQL
      UPDATE books
      SET user_id = reading_logs.user_id,
          status = reading_logs.status,
          comment = reading_logs.comment
      FROM reading_logs
      WHERE reading_logs.book_id = books.id
    SQL

    change_column_null :books, :user_id, false
    change_column_null :books, :status,  false

    drop_table :reading_logs
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
