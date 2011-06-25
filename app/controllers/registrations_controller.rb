class RegistrationsController < Devise::RegistrationsController
  # 認証の対象にshowを含める
  prepend_before_filter :authenticate_scope!, :only => [:show, :edit, :update, :destroy]

  def show
    @user = current_user
  end

end
