class AddOrganizerToMedia < ActiveRecord::Migration
  def change
    add_reference :media, :organizer, index: true
  end
end
