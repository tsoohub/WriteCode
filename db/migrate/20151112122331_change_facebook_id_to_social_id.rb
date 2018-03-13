class ChangeFacebookIdToSocialId < ActiveRecord::Migration
  def change
  	rename_column :students, :facebookId, :social_id
  end
end
