class AddTypeToInstruction < ActiveRecord::Migration
  def change
    add_column :instructions, :type, :integer
  end
end
