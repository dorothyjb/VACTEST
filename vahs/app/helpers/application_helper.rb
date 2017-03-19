module ApplicationHelper
  def title(page_title)
    content_for :title, page_title.to_s
  end

  def nav_class page
    klass = "nav-item nav-link"
    klass += " active" if current_page?(page)
    klass
  end
end
