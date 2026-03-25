class AddIsbnToBooks < ActiveRecord::Migration[8.1]
  def change
    add_column :books, :isbn, :string

    execute <<~SQL
      UPDATE books
      SET isbn = 'TEMP-' || id
    SQL

    change_column_null :books, :isbn, false

    add_index :books, :isbn, unique: true
  end
end
