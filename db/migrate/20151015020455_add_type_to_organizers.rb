class AddTypeToOrganizers < ActiveRecord::Migration
  def change
    add_column :organizers, :type, :integer
  end
end
