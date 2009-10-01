# _*_ coding: utf-8 _*_
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def entity_li(entity)
    content_tag(:li, :class=> "dir") do
      image_tag("icon/#{entity.icon_name}", :size => @icon_size, :class => "entity_icon") +
      link_to(h(entity.name), entity.link_to_action.merge({:id => entity.id}))
    end
  end

  def tag_box(entity)
    %Q{<div id="tag-box-#{entity.id}" class="tag_box">
      <h3>タグ</h3>
      #{tag_list(entity)}
      </div>}
  end

  def tag_list(entity)
    content_tag("div", {:id => "tag-list-#{entity.id}", :class => "tag_list"}) do
      entity.tag_list.inject("") do |str, p_tag|
        str << content_tag("span", {:class => "tag"}) do
          "<a href=\"/tag_search/#{CGI.escape(p_tag)}\">#{h p_tag}</a>"
        end
        str
      end +
      link_to_remote("[編集]", :url => tag_form_open_path(:id => entity), :html => {:href => tag_form_open_path(:id => entity), :class => "tag_edit_link"})
    end
  end

  def tag_list_edit(entity)
    tag_str = ""
    tag_idx = 1
    entity.tag_list.each do |p_tag|
      tag_str += tag_line_edit(entity, p_tag, tag_idx)
      tag_idx += 1
    end
    content_tag("div",
      content_tag("div", tag_str, {:id => "tag-line-box-#{entity.id}"}) +
      tag_edit_form(entity),
    {:id => "tag-list-#{entity.id}", :class => "tag_list_edit"})
  end

  def tag_edit_form(entity)
    tag_str = form_remote_tag :url => tagging_path(:id => entity.id) do
      text_field_tag("tags", "", :size => 50) +
      submit_tag("編集") + " " +
      link_to_remote("[完了]", :url => tag_form_close_path(:id => entity), :html => {:href => tag_form_close_path(:id => entity), :class => "tag_edit_link"})
    end
    tag_str.join("\n")
  end

  def tag_line_edit(entity, p_tag, tag_idx)
    content_tag("div", {:id => "tag-#{entity.id}-#{tag_idx}"}) do
      content_tag("span", {:class => "tag"}) do
        link_to(h(p_tag), tag_search_path(:tag => p_tag)) + " " +
        link_to_remote(image_tag("icon/tag_del_button.png"), {:url => tag_remove_path(:id => entity, :tag => p_tag, :tag_idx => tag_idx), :confirm => "#{p_tag}を削除してよろしいですか？"}, :href => tag_remove_path(:id => entity, :tag => p_tag))
      end
    end
  end

  def search_form
    form_tag(:controller => 'pasokara', :action => 'search', :query => nil, :page => nil) + "\n" +
    content_tag(:label, "曲名・タグ検索: ") +
    text_field_tag("query", params[:query], :size => 32) +
    submit_tag("Search") + "\n" +
    "</form>" + "\n" +
    "半角スペースでAND検索"
  end

  def tag_search_form
    form_tag(:controller => 'pasokara', :action => 'tag_search', :tag => nil, :page => nil) + "\n" +
    content_tag(:label, "タグ検索: ") +
    text_field_tag("tag", "", :size => 32) +
    submit_tag("Search") + "\n" +
    "</form>"
  end

  def scoped_tags(tags)
    form_tag(:action => "append_search_tag") +
    tags.inject("") do |str, t|
      remove_scope = link_to(image_tag("icon/cancel_16.png"), {:remove => t}, :class => "remove_scope")
      str += content_tag(:span, h(t) + remove_scope, :class => "scoped_tag") + " > "
      str
    end +
    hidden_field_tag("tag", params[:tag]) +
    text_field_tag("append", "", :size => 16) +
    submit_tag("タグ追加") +
    "</form>"
  end

  def header_tag_list(tags, url_builder)
    content_tag(:div, :class => "all_tag_list", :id => "all_tag_list") do 
      content_tag("h3", "タグ一覧") +
      tags.inject("") do |str, t|
        str += content_tag(:span, :class => "tag") do
          link_to(h(t.name), url_builder.call(t)) + "(#{t.count})"
        end + "\n"
        str
      end
    end
  end

end
