class AddOrganizerToChapters < ActiveRecord::Migration
  def change
    add_reference :chapters, :organizer, index: true
  end
end
