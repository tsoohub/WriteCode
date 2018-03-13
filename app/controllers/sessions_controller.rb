class SessionsController < ApplicationController
  def create
  	user = User.omniauth(env['omniauth.auth'])

  	if Student.find_by(social_id: user.id).blank?
  		Student.create(fullname: user.name, picture: user.image, social_id: user.id)
  		
  		session[:user_id] = Student.last.id
  	else
  		session[:user_id] = Student.find_by(social_id: user.id).id
  	end
    redirect_to :chapter1

  end

  def destroy
  	session[:user_id] = nil
  	redirect_to :index
  end
end
