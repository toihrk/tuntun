class OmniauthCallbacksController  < Devise::OmniauthCallbacksController

  def twitter
    auth          = request.env["omniauth.auth"]
    twitter_id    = auth["uid"]
    name          = auth["info"]["nickname"]
    nick          = auth["info"]["screen_name"]
    icon_url      = auth["info"]["image"]
    profile       = auth["info"]["description"]
    access_token  = auth["credentials"]["token"]
    access_secret = auth["credentials"]["secret"]

    user = User.find_or_initialize_by(twitter_id: twitter_id)

    user.twitter_id    = twitter_id
    user.name          = name
    user.nick          = nick
    user.icon_url      = icon_url
    user.profile       = profile
    user.access_token  = access_token
    user.access_secret = access_secret
    user.authentication_token = Digest::MD5.new.update(access_secret).to_s

    user.save
    
    #render json: user.to_json
    sign_in_and_redirect user
  end
end
