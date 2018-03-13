class ChangeTypeToStatement < ActiveRecord::Migration
  def change
  	rename_column :instructions, :type, :statement
  end
end
