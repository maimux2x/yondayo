class AddShareTokenToReadings < ActiveRecord::Migration[8.1]
  def change
    add_column :readings, :share_token, :string

    Reading.find_each do |r|
      r.update! share_token: SecureRandom.urlsafe_base64(16)
    end

    change_column_null :readings, :share_token, false

    add_index :readings, :share_token, unique: true
  end
end
