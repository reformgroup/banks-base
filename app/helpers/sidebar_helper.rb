module SidebarHelper
  
  def sidebar_item(link_text, link_path, icon_name, options = {})
    options ||= {}
    
    if available?(options)
      options[:class] = "active" if active?(options)

      link_to(link_path, options.slice(:class)) do
        icon icon_name, link_text, class: "fa-fw"
      end
    end
  end
  
  private
  
  def available?(options)
    options[:available_for_roles].nil? || current_role_include?(*options[:available_for_roles])
  end
  
  def active?(options)
    (options[:active_controllers].nil?  || options[:active_controllers].include?(controller_name)) &&
    (options[:active_actions].nil?      || options[:active_actions].include?(action_name)) &&
    (options[:active_paths].nil?        || options[:active_paths].include?(controller_name))
  end  
end