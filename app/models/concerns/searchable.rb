require 'active_support/concern'

module Searchable
  
  extend ActiveSupport::Concern

  class_methods do
    
    # Returns a collection that match the search parameters.
    # search("Foo Bar", :first_name, :last_name)
    # 
    # # => self.where("(first_name LIKE ? OR last_name LIKE ?) AND (first_name LIKE ? OR last_name LIKE ?)", "%foo%", "%foo%", "%bar%", "%bar%")
    #
    def search(query, *colunms)
      return self unless query
      raise ArgumentError, "Required colunms missing." unless colunms
      
      query         = normalize_search_query query
      query_str     = String.new
      query_params  = Array.new
      
      query.map.with_index do |q, i|
        query_str = "#{query_str} AND " if i > 0
        query_str_item = String.new
        colunms.each do |c|
          query_str_item << " OR " unless query_str_item.blank?
          query_str_item << "#{c} LIKE ?"
          query_params.push "%#{q}%"
        end
        query_str = "#{query_str}(#{query_str_item})"
      end
      
      self.where(query_str, *query_params)
    end
    
    private
    
    def normalize_search_query(query)
      query[0, 50].gsub(/[^[:alpha:][:blank:][:digit:]\-\'\.\_\:]/i, "").gsub(/\s+/i, " ").downcase.split(" ")
    end
  end
end