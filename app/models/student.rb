class Student < ActiveRecord::Base

	attr_accessor :student_validate
	has_many :completeds, dependent: :delete_all
	has_many :lessons, through: :completeds
	has_many :badges, dependent: :delete_all
	has_many :chapters, through: :badges
	has_many :questions, dependent: :delete_all
	has_many :answers, dependent: :delete_all

	mount_uploader :picture, AttachmentUploader 
	validates :fullname, presence: {message: "Овог нэр хоосон"}, if:     Proc.new{|u| u.student_validate == true }
	validates :email, presence: {message: "имэйл хоосон"}, confirmation: {message: "имэйл буруу"}, uniqueness: {message: "бүртгэлтэй имэйл"}, if:     Proc.new{|u| u.student_validate == true }
	validates :username, presence: {message: "х/нэр хоосон"}, uniqueness: {message: "бүртгэлтэй"}, format: { :with => /\A[a-z0-9_-]{3,16}\z/, message: "буруу х/нэр"}, if:     Proc.new{|u| u.student_validate == true }
	validates :password, presence: {message: "нууц үг хоосон"}, format: { :with => /\A[a-z0-9_-]{5,18}\z/, message: "буруу нууц үг"}, if:     Proc.new{|u| u.student_validate == true }
	
end
