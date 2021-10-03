class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build if logged_in?
    @feed_items = current_user.feed.recent_posts.page(params[:page])
                              .per Settings.max_feed_items
  end

  def help; end
end
