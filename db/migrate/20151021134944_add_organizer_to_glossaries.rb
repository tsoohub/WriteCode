class AddOrganizerToGlossaries < ActiveRecord::Migration
  def change
    add_reference :glossaries, :organizer, index: true
  end
end
