class AddAttachmentToChapters < ActiveRecord::Migration
  def change
    add_column :chapters, :attachment, :string
  end
end
