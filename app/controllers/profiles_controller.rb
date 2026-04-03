class ProfilesController < ApplicationController
  def edit
    @profile = Current.user
  end

  def update
    @profile = Current.user

    @profile.update!(profile_params)

    redirect_to :edit, status: :see_other
  end

  private

  def profile_params
    params.expect(profile: [
      :name,
      :email_address,
      :avatar
    ])
  end
end
