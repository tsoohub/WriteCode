class AddFacebookIdToStudent < ActiveRecord::Migration
  def change
    add_column :students, :facebookId, :integer
  end
end
