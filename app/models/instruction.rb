class Instruction < ActiveRecord::Base
	belongs_to :lesson, dependent: :delete

	validates :command, presence: {message: "Заавар хоосон"}, uniqueness: {message: "Бүртгэлтэй заавар"}
	validates :answer, presence: {message: "Хариулт хоосон"}
	validates :statement, presence: {message: "Төрөл хоосон"}

end
