class AddNameToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :name, :string

    reversible do |dir|
      dir.up do
        execute <<~SQL
          UPDATE users
          SET name = SUBSTR(email_address, 1, INSTR(email_address, '@') - 1);
        SQL
      end
    end

    change_column_null :users, :name, false
  end
end
