module ApplicationHelper
  def forum_url
    DISCOURSE_URL
  end

  def forum_link
    link_to t(:forum), forum_url
  end
end
