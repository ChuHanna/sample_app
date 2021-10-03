class FollowersController < ApplicationController
  before_action :logged_in_user, only: %i(following followers)

  def following
    @title = t "shared.stats.following"
    @users = @user.following.page(params[:page])
                  .per Settings.max_item_following
    render "show_follow"
  end

  def followers
    @title = t "shared.stats.followers"
    @user = User.find_by(id: params[:id])
    @users = @user.followers.page(params[:page])
                  .per Settings.max_item_following
    render "show_follow"
  end
end
