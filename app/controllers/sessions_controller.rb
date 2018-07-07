class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create, :failure]
  skip_before_action :verify_authenticity_token, only: [:create]

  def new
    if Rails.env.development?
      user = User.first
      user_sign_in(user)
      redirect_to posts_path
    else
      client_id = Figaro.env.MIXIN_CLIENT_ID
      scope = Figaro.env.MIXIN_DEFAULT_SCOPE
      path = format('https://mixin.one/oauth/authorize?client_id=%s&scope=%s', client_id, scope)

      redirect_to path
    end
  end

  def create
    code = params[:code]
    access_token = MixinTokenManager.access_token(code)
    r = MixinAPI.api_profile.read(access_token)
    user = User.find_or_create_by!(uid: r['data']['user_id'])
    user.update! raw: r['data']
    user_sign_in(user) if user

    redirect_to posts_path
  end

  def failure
    redirect_to root_path
  end

  def destroy
    user_sign_out
    redirect_back(fallback_location: root_path)
  end
end
