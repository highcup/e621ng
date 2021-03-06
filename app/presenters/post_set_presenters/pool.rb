module PostSetPresenters
  class Pool < Base
    attr_reader :post_set
    delegate :posts, :to => :post_set

    def initialize(post_set)
      @post_set = post_set
    end

    def post_previews_html(template)
      html = ""

      if posts.empty?
        return template.render("posts/blank")
      end

      posts.each do |post|
        html << PostPresenter.preview(post, :pool_id => post_set.pool.id, show_cropped: true, show_deleted: true, thumbnail_blacklisted: true)
      end

      html.html_safe
    end
  end
end
