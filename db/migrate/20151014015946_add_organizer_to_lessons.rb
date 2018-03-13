class AddOrganizerToLessons < ActiveRecord::Migration
  def change
    add_reference :lessons, :organizer, index: true
  end
end
