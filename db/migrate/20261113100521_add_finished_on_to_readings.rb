class AddFinishedOnToReadings < ActiveRecord::Migration[8.1]
  def change
    add_column :readings, :finished_on, :date

    # 既存の読了記録は最終更新日（日本時間）を読了日とする
    up_only do
      execute <<~SQL
        UPDATE readings SET finished_on = date(updated_at, '+9 hours') WHERE status = 2
      SQL
    end
  end
end
