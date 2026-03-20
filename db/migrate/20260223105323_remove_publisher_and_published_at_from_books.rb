class RemovePublisherAndPublishedAtFromBooks < ActiveRecord::Migration[8.1]
  def change
    remove_check_constraint :books, "published_at <= CURRENT_DATE"

    remove_column :books, :publisher, :string
    remove_column :books, :published_at, :date
  end
end
