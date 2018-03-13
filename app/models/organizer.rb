class Organizer < ActiveRecord::Base
	 has_many :chapters
	 has_many :medias
	 has_many :lessons
	 has_many :glossaries

	 mount_uploader :attachment, AttachmentUploader # Tells rails to use this uploader for this model.
	 validates :fullname, presence: {message: "Овог нэр хоосон"}
	 validates :email, presence: {message: "Имэйл хоосон"}, confirmation: {message: "имэйл буруу"}, uniqueness: {message: "бүртгэлтэй имэйл"}
	 validates :major, presence: {message: "Мэргэжил хоосон"}
	 validates :attachment, presence: {message: "Зураг хоосон"}
	 validates :password, presence: {message: "Нууц үг хоосон"}, format: { :with => /\A[a-z0-9_-]{5,18}\z/, message: "буруу нууц үг"}
	 validates :about_me, presence: {message: "Тухай хоосон"}
	 self.inheritance_column = nil 
end	
