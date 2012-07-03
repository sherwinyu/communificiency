module ApplicationHelper
  def full_title page_title
    base_title = 'Communificiency'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  # canonical inner, options
  def nav_li_tag(*args, &block)
    if block_given?
      options = args.first || {}
      # \winner = capture(&block).html_safe
      inner = block.call.html_safe
      nav_li_tag(inner, options)
    else
      inner = args[0]
      options = args[1] || {}
      # url = url_for(options)

      str = current_page?(options) ? '<li class="active">' : '<li>'
      if current_page?(options)
        str << "<p class='navbar-text'>"
        str << inner
        str << '</p>'
      else
        str << ( link_to inner, options )
      end
      str << '</li>'
      str.html_safe
    end
  end





    def nav_li_tag2(inner, path )
      inner = inner.html_safe
      str = current_page?(path) ? '<li class="active">' : '<li>'
      unless current_page?(path)
        str << ( link_to inner, path )
      else
        str << "<p class='navbar-text'>"
        str << inner
        str << '</p>'
      end
      str << '</li>'
      str.html_safe
    end

    def navigation_li_text text
      "<p class=\"navbar-text\">#{text}</p>".html_safe
    end
  end
