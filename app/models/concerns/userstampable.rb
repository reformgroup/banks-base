require 'active_support/concern'

module Userstampable
  
  module Stampable
    
    extend ActiveSupport::Concern
    
    included do
      belongs_to :creator, class_name: "User", foreign_key: :creator_id         
      belongs_to :updater, class_name: "User", foreign_key: :updater_id
    
      before_create :set_creator_attribute
      before_save   :set_updater_attribute
    end
    
    def set_creator_attribute
      self.send "creator_id=", User.stamper
    end
    
    def set_updater_attribute
      self.send "updater_id=", User.stamper
    end
  end
  
  module Stamper
    
    extend ActiveSupport::Concern
    
    class_methods do
      # Used to set the stamper for a particular request. See the Userstamp module for more
      # details on how to use this method.
      def stamper=(object)
        object_stamper = if object.is_a?(ActiveRecord::Base)
          object.send("#{object.class.primary_key}".to_sym)
        else
          object
        end

        Thread.current["#{self.to_s.downcase}_#{self.object_id}_stamper"] = object_stamper
      end

      # Retrieves the existing stamper for the current request.
      def stamper
        Thread.current["#{self.to_s.downcase}_#{self.object_id}_stamper"]
      end

      # Sets the stamper back to +nil+ to prepare for the next request.
      def reset_stamper
        Thread.current["#{self.to_s.downcase}_#{self.object_id}_stamper"] = nil
      end
    end
  end
  
  module Controller
    
    extend ActiveSupport::Concern
    
    included do
      before_filter  :set_stamper
      after_filter   :reset_stamper
    end
    
    private
    
    # The <tt>set_stamper</tt> method as implemented here assumes a couple
    # of things. First, that you are using a +User+ model as the stamper
    # and second that your controller has a <tt>current_user</tt> method
    # that contains the currently logged in stamper. If either of these
    # are not the case in your application you will want to manually add
    # your own implementation of this method to the private section of
    # the controller where you are including the Userstamp module.
    def set_stamper
      User.stamper = self.current_user
    end

    # The <tt>reset_stamper</tt> method as implemented here assumes that a
    # +User+ model is being used as the stamper. If this is not the case then
    # you will need to manually add your own implementation of this method to
    # the private section of the controller where you are including the
    # Userstamp module.
    def reset_stamper
      User.reset_stamper
    end
  end
end

ActionController::Base.send(:include, Userstampable::Controller) if defined?(ActionController)