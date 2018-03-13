class User < ActiveRecord::Base
	def self.omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.image = auth.info.image
      user.token = auth.credentials.token
      if user.provider != "github"
        user.expires_at = Time.at(auth.credentials.expires_at)
      end
      user.save!
    end
	end
end
