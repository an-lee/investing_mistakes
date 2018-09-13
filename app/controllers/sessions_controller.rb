class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create, :failure]
  skip_before_action :verify_authenticity_token, only: [:create]

  def new
    if Figaro.env.SESSION_DEBUG_MODE.present?
      user = User.first
      user_sign_in(user)
      redirect_to posts_path
    else
      path = format('https://mixin.one/oauth/authorize?client_id=%s&scope=%s', client_id, scope)

      redirect_to MixinBot.api.request_oauth
    end
  end

  def create
    code = params[:code]
    user = User.auth_from_mixin(code)
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
