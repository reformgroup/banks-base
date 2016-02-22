require 'active_support/concern'

module Filterable
  
  extend ActiveSupport::Concern

  class_methods do
    
    # Returns a sorted collection.
    def filter(query, *filter_params)
      return unless query
      raise ArgumentError, "Required parameter missing." unless filter_params
      
      query = query.gsub(/[^a-z_]/, "")
      
      filter_type = query.slice(/(_asc|_desc)\z/).gsub("_", "").upcase
      query.gsub!(/(_asc|_desc)\z/, "")
      
      self.order("#{query} #{filter_type}") if filter_params.include? query.to_sym
    end
  end
end