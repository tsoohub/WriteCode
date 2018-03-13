class Media < ActiveRecord::Base
	self.table_name = "medias"

	include Filterable

	belongs_to :organizer
	mount_uploader :attachment, AttachmentUploader # Tells rails to use this uploader for this model
	mount_uploader :video, VideoUploader

	validates :name, presence: {message: "Видео нэр хоосон"}, uniqueness: {message: "Бүртгэлтэй нэр"}, :on => :create
	validates :attachment, presence: {message: "Зураг хоосон"}
	validates :video, presence: {message: "Видео хоосон"}
end
