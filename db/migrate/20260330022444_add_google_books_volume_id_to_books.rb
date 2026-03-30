class AddGoogleBooksVolumeIdToBooks < ActiveRecord::Migration[8.1]
  def up
    add_column :books, :google_books_volume_id, :string

    execute <<~SQL
      UPDATE books
      SET google_books_volume_id = 'VOLUME-' || id
    SQL

    change_column_null :books, :google_books_volume_id, false

    add_index :books, :google_books_volume_id, unique: true

    remove_column :books, :isbn
  end

  def down
    add_column :books, :isbn, :string

    execute <<~SQL
      UPDATE books
      SET isbn = 'TEMP-' || id
    SQL

    change_column_null :books, :isbn, false

    add_index :books, :isbn, unique: true

    remove_column :books, :google_books_volume_id
  end
end
