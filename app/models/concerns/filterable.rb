module Filterable
  
  extend ActiveSupport::Concern

  module ClassMethods
    
    # Returns a sorted collection.
    def filter(query, *filter_params)
      return unless query
      raise ArgumentError, "Required parameter missing." unless filter_params
      
      query.gsub!(/[^a-z_]/, "")
      
      filter_type = query.slice(/(_asc|_desc)\z/).gsub("_", "").upcase
      query.gsub!(/(_asc|_desc)\z/, "")
      
      logger.debug "++++++++++++++++++++++++++++++++++++++++++++++++"
      logger.debug filter_params
      logger.debug query
      logger.debug filter_type
      
      if filter_params.include? query.to_sym
        self.order("#{query} #{filter_type}")
      else
        self
      end
    end
  end
end