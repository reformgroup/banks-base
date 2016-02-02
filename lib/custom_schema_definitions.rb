module ActiveRecord
  module ConnectionAdapters #:nodoc:
    class TableDefinition
      
      # Adds a deleted_at column when timestamps is called from a migration.
      def timestamps_with_deleted_at(options = {})
        include_deleted_at = options.delete(:include_deleted_at)
        timestamps_without_deleted_at(options)
        column(:deleted_at, :datetime) if include_deleted_at
      end
      
      alias_method_chain :timestamps, :deleted_at
      
      # Adds a creator_id, updater_id and [deleter_id] columns when userstamps is called from a migration.
      def userstamps(options = {})
        include_deleter_id = options.delete(:include_deleter_id)
        
        references(:creator, options.merge(foreign_key: { column: :creator_id }))
        references(:updater, options.merge(foreign_key: { column: :updater_id }))
        references(:deleter, options.merge(foreign_key: { column: :deleter_id })) if include_deleter_id
      end
    end
  end
end