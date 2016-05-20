class User < ActiveRecord::Base

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.avatar_url = "http://graph.facebook.com/#{user.uid}/picture?type=normal"
      if auth['info']
        user.name = auth['info']['name'] || ""
      end
    end
  end
end
