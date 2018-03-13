class Chapter < ActiveRecord::Base
	has_many :badges, dependent: :delete_all
	has_many :students, through: :badges

	belongs_to :organizer
	has_many :lessons 
	mount_uploader :attachment, AttachmentUploader # Tells rails to use this uploader for this model.
	
	validates :name, presence: {message: "Бүлгийн нэр хоосон"}, uniqueness: {message: "Бүртгэлтэй нэр"}, :on => :new
	validates :badge_name, presence: {message: "Урамшуулал хоосон"}, uniqueness: {message: "Бүртгэлтэй урамшуулал"}, :on => :new
	validates :description, presence: {message: "Тайлбар хоосон"}, :on => :new
	validates :attachment, presence: {message: "Зураг хоосон"}
	
end
