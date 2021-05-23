class ChangeApplicationsZipCode < ActiveRecord::Migration[5.2]
  def up
    change_table :applications do |t|
      t.change :zip_code, :string
    end
  end
  def down
    change_table :applications do |t|
      t.change :zip_code, :integer
    end
  end
end
