class Glossary < ActiveRecord::Base
	belongs_to :organizer

	validates :name, presence: {message: "Тайлбар нэр хоосон"}, uniqueness: {message: "Бүртгэлтэй тайлбар"}, length: { maximum: 50, message: "хэтэрхий урт нэр"}
	validates :description, presence: {message: "Тодорхойлолт хоосон"}
	validates :syntax, presence: {message: "Синтакс хоосон"}
	validates :example, presence: {message: "Жишээ хоосон"}
	
end
