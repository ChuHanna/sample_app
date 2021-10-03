class UsersController < ApplicationController
  before_action :find_by_user, except: %i(index new create)
  before_action :logged_in_user, except: %i(new create show)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.all.page(params[:page]).per Settings.show_5
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_mail_activate
      flash[:info] = t "activatedinfo"
      redirect_to login_url
    else
      flash[:danger] = t "activatedfail"
      render :new
    end
  end

  def show
    @microposts = @user.microposts.recent_posts.page(params[:page])
                       .per Settings.max_feed_items
  end

  def edit; end

  def update
    if @user.update_attribute user_params
      flash[:success] = t "profileupdated"
      redirect_to @user
    else
      flash[:danger] = t "updatefaild"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "userdeleted"
    else
      flash[:danger] = t "deletefail"
    end
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit User::PROPERTIES
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to(root_url) unless current_user?(@user)
  end

  def find_by_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "usernotfound"
    redirect_to root_url
  end
end
