class Answer < ActiveRecord::Base
	belongs_to :question
	belongs_to :student

	mount_uploader :picture, AttachmentUploader # Tells rails to use this uploader for this model.
end
