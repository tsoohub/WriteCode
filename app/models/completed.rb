class Completed < ActiveRecord::Base
	belongs_to :lesson
	belongs_to :student
end
