class ChangeDataTypeForAnswer < ActiveRecord::Migration
  def change
  	change_table :lessons do |t|
  		t.change :answer, :text
  	end
  end
end
