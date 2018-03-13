class AddVideoToMedia < ActiveRecord::Migration
  def change
    add_column :media, :video, :string
  end
end
