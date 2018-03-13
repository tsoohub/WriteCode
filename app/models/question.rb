class Question < ActiveRecord::Base
	has_many :answers, dependent: :delete_all
	belongs_to :student

	mount_uploader :picture, AttachmentUploader # Tells rails to use this uploader for this model.
	validates :ques, presence: {message: "Асуулт хоосон байна"}, uniqueness: {message: "Асуугдсан асуулт байна"}
	validates :category, presence: {message: "category сонгоогүй"}
	
end
