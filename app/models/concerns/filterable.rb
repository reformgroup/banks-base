module Filterable
  
  extend ActiveSupport::Concern

  module ClassMethods
    
    # Returns a sorted collection.
    def filter(query, *attributes)
      return unless query
      raise ArgumentError, "Required parameter missing." unless attributes
      
      self.order(email: :desc)
    end
  end
end