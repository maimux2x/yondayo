class AddMemoToReadings < ActiveRecord::Migration[8.1]
  def change
    add_column :readings, :memo, :string
  end
end
