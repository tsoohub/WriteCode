class Badge < ActiveRecord::Base
	belongs_to :student
	belongs_to :chapter
end