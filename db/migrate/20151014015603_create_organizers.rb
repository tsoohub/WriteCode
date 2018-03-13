class CreateOrganizers < ActiveRecord::Migration
  def change
    create_table :organizers do |t|
      t.string :fullname
      t.string :email
      t.string :password
      t.string :picture
      t.string :major
      t.text :about_me

      t.timestamps
    end
  end
end
