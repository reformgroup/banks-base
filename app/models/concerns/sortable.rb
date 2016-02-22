require 'active_support/concern'

module Sortable
  
  extend ActiveSupport::Concern

  class_methods do
    
    # Returns a sorted collection.
    def sort(sort_param, direction_param = nil)
      column    = sort_column sort_param
      direction = sort_direction direction_param
      self.order("#{column} #{direction}") if column && direction
    end
    
    private
  
    def sort_column(sort_param)
      if self.column_names.include?(sort_param)
        sort_param
      else
        return "name"       if self.column_names.include?("name")
        return "last_name"  if self.column_names.include?("last_name")
        return "created_at" if self.column_names.include?("created_at")
      end
    end

    def sort_direction(direction_param = nil)
      %w[asc desc].include?(direction_param) ? direction_param : "asc"
    end
  end
end