class AllowNullToAuthorOnBooks < ActiveRecord::Migration[8.1]
  def change
    change_column_null :books, :author, true
  end
end
