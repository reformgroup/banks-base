module BootstrapHelper
  
  def button_dropdown_tag(name, title, content_or_options = nil, options = nil, &block)
    dropdown_tag(:button, name, title, content_or_options, options, &block)
  end
  
  def link_dropdown_tag(name, title, content_or_options = nil, options = nil, &block)
    dropdown_tag(:a, name, title, content_or_options, options, &block)
  end
  
  #   options_for_dropdown( ["Free", free_path, selected: true], 
  #                         ["Basic", basic_path], 
  #                         ["Advanced", advanced_path], 
  #                         ["Super Platinum", super_platinum_path, disabled: true])
  #   
  #   # => <a class="dropdown-item" href="#"><i class="fa fa-fw fa-check"></i> Free</a>
  #   # => <a class="dropdown-item" href="#">Basic</a>
  #   # => <a class="dropdown-item" href="#">Advanced</a>
  #   # => <a class="dropdown-item" disabled="disabled" href="#">Super Platinum</a>
  #
  def options_for_dropdown(content)
    if content.is_a Array
      content.each do |option_tag|
        name = option_tag[0]
        url  = option_tag[1]
        option_for_dropdown(name, url, option_tag[2])
      end.html_safe
    end
  end
  
  def option_for_dropdown(name, url, options = {})
    options         ||= {}
    select_icon     = options.delete(:selected) ? "check" : nil
    link_content    = icon select_icon, name, class: "fa-fw"
    options[:class] = ["dropdown-item", options[:class]].compact.join(" ")
    
    link_to link_content, url, options
  end
  
  private
  
  def dropdown_tag(tag_name, name, title, content_or_options = nil, options = nil, &block)
    raise ArgumentError, "Missing block or content" unless block_given? || content_or_options
    
    if block_given?
      content_or_options ||= {}
      options, content_or_options = content_or_options, capture(&block)
    else
      options ||= {}
    end
    
    main_class = tag_name == :button ? "btn-group" : "dropdown"
    main_class = [main_class, options.delete(:main_class)].compact.join(" ")
    
    options["id"]            ||= "dropdown_#{name}"
    options["data-toggle"]   ||= "dropdown"
    options["aria-haspopup"] ||= "true"
    options["aria-expanded"] ||= "false"
    options[:btn_style]      ||= "secondary" if tag_name == :button
    options[:class] = ["btn dropdown-toggle btn-#{options.delete(:btn_style)}", options[:class]].compact.join(" ")
    
    content = content_tag(:div, class: "dropdown-menu") { content_or_options }
    content_tag(:div, class: main_class) do
      if tag_name == :button
        button_tag(title, options).concat(content)
      else
        link_to(title, "javascript:;", options).concat(content)
      end
    end
  end
end