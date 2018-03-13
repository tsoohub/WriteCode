class AddAttachmentToOrganizers < ActiveRecord::Migration
  def change
    add_column :organizers, :attachment, :string
  end
end
