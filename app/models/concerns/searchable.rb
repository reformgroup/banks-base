module Searchable
  
  extend ActiveSupport::Concern

  module ClassMethods
    
    # Returns a collection that match the search parameters.
    def search(query, *attributes)
      return unless query
      raise ArgumentError, "Required parameter missing." unless attributes
      
      query.gsub!(/[^[:alpha:][:blank:][:digit:]\-\'\.\_\:]/i, "")
      query           = query.split(" ").map { |q| "%#{q}%" }
      query_arr       = []
      sql_str         = ""
      query_for_attr  = ""
    
      attributes.each do |a| 
        query_for_attr << " OR "  unless query_for_attr.blank?
        query_for_attr << "#{a} LIKE ?"
      end
    
      query.each do |q|
        sql_str << " AND " unless sql_str.blank?
        sql_str << "(#{query_for_attr})"
        query_arr = query_arr + [q]*attributes.size
      end
    
      self.where(sql_str, *query_arr)
    end
  end
end