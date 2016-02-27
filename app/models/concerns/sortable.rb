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
      if sort_param && self.column_names.include?(sort_param)
        sort_param
      else
        default_sort_columns.each do |column|
          return column if self.column_names.include?(column)
        end
      end
    end

    def sort_direction(direction_param = nil)
      %w[asc desc].include?(direction_param) ? direction_param : "asc"
    end
    
    def default_sort_columns
      ["name", "last_name", "created_at"]
    end
  end
end