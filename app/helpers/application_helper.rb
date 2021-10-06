module ApplicationHelper
  def full_title page_title
    base_title = t("base_title")
    page_title.empty? ? base_title : [page_title, base_title].join(" | ")
  end

  def find_followed user
    current_user.active_relationships.find_by followed_id: user.id
  end
end
