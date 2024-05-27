# frozen_string_literal: true
class BidirectionalLinksGeneratorBlog < Jekyll::Generator
  def generate(site)
    graph_nodes = []
    graph_edges = []

    all_blogs = site.collections['blog'].docs
    all_pages = site.pages

    all_docs = all_blogs + all_pages

    link_extension = !!site.config["use_html_extension"] ? '.html' : ''

    # Convert all Wiki/Roam-style double-bracket link syntax to plain HTML
    # anchor tag elements (<a>) with "internal-link" CSS class
    all_docs.each do |current_blog|
      all_docs.each do |blog_potentially_linked_to|
        blog_title_regexp_pattern = Regexp.escape(
          File.basename(
            blog_potentially_linked_to.basename,
            File.extname(blog_potentially_linked_to.basename)
          )
        ).gsub('\_', '[ _]').gsub('\-', '[ -]').capitalize

        title_from_data = blog_potentially_linked_to.data['title']
        if title_from_data
          title_from_data = Regexp.escape(title_from_data)
        end

        new_href = "#{site.baseurl}#{blog_potentially_linked_to.url}#{link_extension}"
        anchor_tag = "<a class='internal-link' href='#{new_href}'>\\1</a>"

        # Replace double-bracketed links with label using blog title
        # [[A blog about cats|this is a link to the blog about cats]]
        current_blog.content.gsub!(
          /\[\[#{blog_title_regexp_pattern}\|(.+?)(?=\])\]\]/i,
          anchor_tag
        )

        # Replace double-bracketed links with label using blog filename
        # [[cats|this is a link to the blog about cats]]
        current_blog.content.gsub!(
          /\[\[#{title_from_data}\|(.+?)(?=\])\]\]/i,
          anchor_tag
        )

        # Replace double-bracketed links using blog title
        # [[a blog about cats]]
        current_blog.content.gsub!(
          /\[\[(#{title_from_data})\]\]/i,
          anchor_tag
        )

        # Replace double-bracketed links using blog filename
        # [[cats]]
        current_blog.content.gsub!(
          /\[\[(#{blog_title_regexp_pattern})\]\]/i,
          anchor_tag
        )
      end

      # At this point, all remaining double-bracket-wrapped words are
      # pointing to non-existing pages, so let's turn them into disabled
      # links by greying them out and changing the cursor
      current_blog.content = current_blog.content.gsub(
        /\[\[([^\]]+)\]\]/i, # match on the remaining double-bracket links
        <<~HTML.delete("\n") # replace with this HTML (\\1 is what was inside the brackets)
          <span title='There is no blog that matches this link.' class='invalid-link'>
            <span class='invalid-link-brackets'>[[</span>
            \\1
            <span class='invalid-link-brackets'>]]</span></span>
        HTML
      )
    end

    # Identify blog backlinks and add them to each blog
    all_blogs.each do |current_blog|
      # Nodes: Jekyll
      blogs_linking_to_current_blog = all_blogs.filter do |e|
        e.content.include?(current_blog.url)
      end

      # Nodes: Graph
      graph_nodes << {
        id: blog_id_from_blog(current_blog),
        path: "#{site.baseurl}#{current_blog.url}#{link_extension}",
        label: current_blog.data['title'],
      } unless current_blog.path.include?('_blogs/index.html')

      # Edges: Jekyll
      current_blog.data['backlinks'] = blogs_linking_to_current_blog

      # Edges: Graph
      blogs_linking_to_current_blog.each do |n|
        graph_edges << {
          source: blog_id_from_blog(n),
          target: blog_id_from_blog(current_blog),
        }
      end
    end
  end

  def blog_id_from_blog(blog)
    blog.data['title'].bytes.join
  end
end
