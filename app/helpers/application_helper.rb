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

  def generic_fields_for( object, options = {})

  end

  def generic_form_field(object, f, column, options = {})
    options[:exclude] ||= [:id, :created_at, :updated_at]
    return if options[:exclude] && options[:exclude].include?(column.name.to_sym)

    return case column.type
    when -> t {t == :integer && column.name =~ /_id$/}
      column_class = column.name.gsub(/_id$/, '').classify.constantize
      if column_class
        collection_select(object.class.name.underscore.to_sym, column.name.to_sym, column_class.all, :id, :name, :prompt => true) 
      else
        f.text_field column.name.to_sym
      end
    when -> t { [:integer, :float, :decimal, :primary_key].include? t}
      f.number_field column.name.to_sym
    when :string
      f.text_field column.name.to_sym
    when :text
      f.text_area column.name.to_sym, size: '25x10', class: 'span8'
    when :boolean
      f.check_box column.name.to_sym
    when :datetime
      f.datetime_select column.name.to_sym
    when :timestamp
      f.time_select column.name.to_sym
    when :time
      f.time column.name.to_sym
    when :date
      f.date column.name.to_sym
    when :boolean
    else
      raise "Unknown column type"
    end
  end

  def markdown text, extensions={}
    require 'redcarpet'
    raw Redcarpet::Markdown.new(Redcarpet::Render::HTML.new, extensions).render text
  end

  def find_asset filename
    Communificiency::Application.assets.find_asset(filename)
  end

end
