module Userstampable  
  extend ActiveSupport::Concern

  included do
    class_attribute :record_userstamps
    self.record_userstamps = true
  end

  private

  def _create_record
    if self.record_userstamps

      all_userstamp_attributes.each do |column|
        column = column.to_s
        if has_attribute?(column) && !attribute_present?(column)
          write_attribute(column, current_user)
        end
      end
    end

    super
  end

  def _update_record(*args, touch: true, **options)
    if touch && should_record_userstamps?

      userstamp_attributes_for_update_in_model.each do |column|
        column = column.to_s
        next if attribute_changed?(column)
        write_attribute(column, current_user)
      end
    end
    
    super(*args)
  end

  def should_record_userstamps?
    self.record_usertamps && (!partial_writes? || changed?)
  end

  def usertamp_attributes_for_create_in_model
    usertamp_attributes_for_create.select { |c| self.class.column_names.include?(c.to_s) }
  end

  def usertamp_attributes_for_update_in_model
    usertamp_attributes_for_update.select { |c| self.class.column_names.include?(c.to_s) }
  end

  def all_usertamp_attributes_in_model
    usertamp_attributes_for_create_in_model + usertamp_attributes_for_update_in_model
  end

  def usertamp_attributes_for_update
    [:updater_id, :updated_by]
  end

  def usertamp_attributes_for_create
    [:creator_id, :created_by]
  end

  def all_usertamp_attributes
    usertamp_attributes_for_create + usertamp_attributes_for_update
  end

  def current_user
    super
  end

  # Clear attributes and changed_attributes
  def clear_usertamp_attributes
    all_usertamp_attributes_in_model.each do |attribute_name|
      self[attribute_name] = nil
      clear_attribute_changes([attribute_name])
    end
  end
end