# frozen_string_literal: true
class BidirectionalLinksGenerator < Jekyll::Generator
  def generate(site)
    graph_nodes = []
    graph_edges = []

    all_infos = site.collections['info'].docs
    all_pages = site.pages

    all_docs = all_infos + all_pages

    link_extension = !!site.config["use_html_extension"] ? '.html' : ''

    # Convert all Wiki/Roam-style double-bracket link syntax to plain HTML
    # anchor tag elements (<a>) with "internal-link" CSS class
    all_docs.each do |current_info|
      all_docs.each do |info_potentially_linked_to|
        info_title_regexp_pattern = Regexp.escape(
          File.basename(
            info_potentially_linked_to.basename,
            File.extname(info_potentially_linked_to.basename)
          )
        ).gsub('\_', '[ _]').gsub('\-', '[ -]').capitalize

        title_from_data = info_potentially_linked_to.data['title']
        if title_from_data
          title_from_data = Regexp.escape(title_from_data)
        end

        new_href = "#{site.baseurl}#{info_potentially_linked_to.url}#{link_extension}"
        anchor_tag = "<a class='internal-link' href='#{new_href}'>\\1</a>"

        # Replace double-bracketed links with label using info title
        # [[A info about cats|this is a link to the info about cats]]
        current_info.content.gsub!(
          /\[\[#{info_title_regexp_pattern}\|(.+?)(?=\])\]\]/i,
          anchor_tag
        )

        # Replace double-bracketed links with label using info filename
        # [[cats|this is a link to the info about cats]]
        current_info.content.gsub!(
          /\[\[#{title_from_data}\|(.+?)(?=\])\]\]/i,
          anchor_tag
        )

        # Replace double-bracketed links using info title
        # [[a info about cats]]
        current_info.content.gsub!(
          /\[\[(#{title_from_data})\]\]/i,
          anchor_tag
        )

        # Replace double-bracketed links using info filename
        # [[cats]]
        current_info.content.gsub!(
          /\[\[(#{info_title_regexp_pattern})\]\]/i,
          anchor_tag
        )
      end

      # At this point, all remaining double-bracket-wrapped words are
      # pointing to non-existing pages, so let's turn them into disabled
      # links by greying them out and changing the cursor
      current_info.content = current_info.content.gsub(
        /\[\[([^\]]+)\]\]/i, # match on the remaining double-bracket links
        <<~HTML.delete("\n") # replace with this HTML (\\1 is what was inside the brackets)
          <span title='There is no info that matches this link.' class='invalid-link'>
            <span class='invalid-link-brackets'>[[</span>
            \\1
            <span class='invalid-link-brackets'>]]</span></span>
        HTML
      )
    end

    # Identify info backlinks and add them to each info
    all_infos.each do |current_info|
      # Nodes: Jekyll
      infos_linking_to_current_info = all_infos.filter do |e|
        e.content.include?(current_info.url)
      end

      # Nodes: Graph
      graph_nodes << {
        id: info_id_from_info(current_info),
        path: "#{site.baseurl}#{current_info.url}#{link_extension}",
        label: current_info.data['title'],
      } unless current_info.path.include?('_infos/index.html')

      # Edges: Jekyll
      current_info.data['backlinks'] = infos_linking_to_current_info

      # Edges: Graph
      infos_linking_to_current_info.each do |n|
        graph_edges << {
          source: info_id_from_info(n),
          target: info_id_from_info(current_info),
        }
      end
    end

    File.write('_includes/infos_graph.json', JSON.dump({
      edges: graph_edges,
      nodes: graph_nodes,
    }))
  end

  def info_id_from_info(info)
    info.data['title'].bytes.join
  end
end
