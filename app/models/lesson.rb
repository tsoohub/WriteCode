class Lesson < ActiveRecord::Base
	belongs_to :chapter
	belongs_to :organizer
	has_many :completeds, dependent: :delete_all
	has_many :students, through: :completeds
	has_many :instructions, dependent: :delete_all

	validates :name, presence: {message: "Хичээлийн нэр хоосон"}, uniqueness: {message: "Бүртгэлтэй хичээлийн нэр"}, length: { maximum: 50, message: "хэтэрхий урт нэр"}
	validates :theory, presence: {message: "Онол хоосон"}
	validates :instruction, presence: {message: "Заавар хоосон"}
	validates :score, presence: {message: "Оноо хоосон"}, length: { maximum: 4, message: "хэтэрхий их оноо"}
	validates :chapter_id, presence: {message: "Бүлэг хоосон"}
	validates :organizer_id, presence: {message: "Зохион байгуулагч хоосон"}

end
