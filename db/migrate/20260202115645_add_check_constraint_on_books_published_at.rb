class AddCheckConstraintOnBooksPublishedAt < ActiveRecord::Migration[8.1]
  def change
    add_check_constraint :books, "published_at <= CURRENT_DATE"
  end
end
