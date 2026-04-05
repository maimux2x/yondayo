class ProfilesController < ApplicationController
  def edit
    @profile = Current.user
  end

  def update
    @profile = Current.user

    @profile.update!(user_params)

    redirect_to edit_profile_path, status: :see_other, notice: '更新しました。'
  end

  private

  def user_params
    params.expect(user: [
      :name,
      :email_address,
      :avatar
    ])
  end
end
