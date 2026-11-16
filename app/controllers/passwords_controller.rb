class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_password_path, alert: 'しばらく時間をおいてから、もう一度お試しください。', status: :see_other }

  def new
  end

  def create
    if user = User.find_by(email_address: params[:email_address])
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to new_session_path, notice: 'パスワード再設定の案内を送信しました（登録済みのメールアドレスの場合）。', status: :see_other
  end

  def edit
  end

  def update
    if @user.update(params.permit(:password, :password_confirmation))
      @user.sessions.destroy_all
      redirect_to new_session_path, notice: 'パスワードを再設定しました。', status: :see_other
    else
      redirect_to edit_password_path(params[:token]), alert: 'パスワードが一致しません。', status: :see_other
    end
  end

  private
    def set_user_by_token
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_path, alert: 'パスワード再設定のリンクが無効か、有効期限が切れています。', status: :see_other
    end
end
