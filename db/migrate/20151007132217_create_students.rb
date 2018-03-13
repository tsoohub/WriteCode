class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :fullname
      t.string :email
      t.string :username
      t.string :password
      t.string :picture
      t.string :location
      t.integer :total_score
      t.text :about
      t.string :last_code

      t.timestamps
    end
  end
end
