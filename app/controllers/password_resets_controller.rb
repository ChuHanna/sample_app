class PasswordResetsController < ApplicationController
  before_action :find_by_user, :valid_user,
                :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "resetinfo"
      redirect_to root_url
    else
      flash.now[:danger] = t "resetfail"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password, t("empty")
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.update_attribute :reset_digest, nil
      flash[:success] = t "passwordresetsuccess"
      redirect_to @user
    else
      flash[:danger] = t "passwordresetfailed"
      render :edit
    end
  end

  private
  def find_by_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "usernotfound"
    redirect_to root_url
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "exprired"
    redirect_to new_password_reset_url
  end

  def user_params
    params.require(:user).permit User::PASSWORD_PARAMS
  end
end
