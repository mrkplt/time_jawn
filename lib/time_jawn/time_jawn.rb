# The base module of the TimeJawn gem. Everything in here assumes that your model has a valid time zone
# in a attribute name time_zone or has been delegating one to somewhere else.
module TimeJawn
  # Automatically runs and adds ClassMethods to ActiveRecord::Base
  def self.included(base)
    base.send :extend, ClassMethods
  end
  

  # Defines private methods necessary for TimeJawn to work. 
  module TimeJawnPrivateClassMethods
    # Locates all of an ActiveRecord class' DateTime Attributes and returns them as an array of symbols.
    def _datetime_attributes
      ActiveSupport::Deprecation.warn "_datetime_attributes will be made private in a future version."
      klass = name.constantize

      datetime_attributes = []
      klass.columns.each do |column|
         datetime_attributes << column.name.to_sym if column.type == :datetime
      end
      return datetime_attributes
    end

    private

    # generates an instance method called "local_#{attribute}" that calls the _to_local instance method.
    def _generate_to_local(attribute)
      define_method(:"local_#{attribute}") { _to_local(send(attribute)) }
    end

    # generates an instance method called "local_#{attribute}=" that calls either the _add_zone or _change_zone
    # instance methods depending on teh class of the input.
    def _generate_to_local_with_assignment(attribute)
      define_method(:"local_#{attribute}=") do |time_or_string_value|
        if time_or_string_value.is_a? String
          write_attribute(attribute, _add_zone(time_or_string_value))
        else
          write_attribute(attribute, _change_zone(time_or_string_value))
        end
      end
    end
  end
  
  # Defines methods that will attached to all ActiveRecord classes.
  module ClassMethods
    include TimeJawnPrivateClassMethods
    # When called it loads the methods located in InstanceMethods.
    # It is typically included in a model's rb file so that instances of that class gain the InstanceMethods at each instantiation.
    #     class Event<ActiveRecord::Base
    #       has_time_zone
    #     end 
    def has_time_zone
      send :include, InstanceMethods
    end
  end

  
  
  #Defines methods that will be added to instances of classes that have previously called has_time_zone.
  module InstanceMethods
    # This method generates a series of methods on instances by calling the _generate_to_local and
    #  _generate_to_local_with_assignment that are private on teh parent class. The methods that are created are called
    # local_#{attribue} and local_#{attribute}= the attribute portion their names are completed by enumerating
    # the datetime_attributes of the class. Twice as many methods as there are DateTime attributes will 
    # be created.
    # 
    #    :created_at, and :updated_at
    #     
    #     local_created_at
    #     local_updated_at
    #     local_created_at=
    #     local_updated_at=
    # 
    # The local_#{attribue} methods will take the value stored in the attribute indicated by the methods name
    # and apply a time zone conversion to it. This is useful for displaying the local time (according to the object).
    # 
    # local_#{attribute}= methods are assignment shortcuts. They behave a little differently than you would expect.
    # They do not take a local time and convert it into utc (or whatever, ActiveSupport will handle that for us), 
    # what these assigment methods do is take any sort of string that looks like a time, or any sort of time or datetime 
    # object lop off whatever timezone is being fed in and glue the instances local timezone on the end before applying 
    # it to the appropriate attribute. This is convenient for some one in one time zone setting a value for an instance 
    # that represents a different time zone. For example:
    #
    #     I am in Philadelphia (EST), my application is set to UTC, and I want to set the time on an Alarm instance that 
    #     goes off in San Francisco (PST). I want that time to be 6PM. In Philadlephia I choose 6PM (local), the applications assumes I 
    #     meant 6PM UTC (2PM EST and 11AM PST). That is not what I intended, I intended on 6PM PST, and now my Alarm is all wrong.
    #     The assignment methods turn 6PM (set in EST, and processed in UTC) into 6PM PST (or 9PM EST, 1AM UTC) the expected time. The
    #     Alarm goes off as expected!*
    #
    #     *Times in this example may be wrong since I put them in myself.
    #
    # You can see examples of how these methods work in the specs folder.
    def self.included(base)
      (base.send :_datetime_attributes).each do |attribute|
        base.send(:_generate_to_local, attribute)
        base.send(:_generate_to_local_with_assignment, attribute)
      end
    end
    # Returns the current time according to the instance.
    def current_time
      _to_local(DateTime.current)
    end
    # converts a time object into it's local counter part (they will have the same value but differnt presentation.)
    def _to_local(time)
      ActiveSupport::Deprecation.warn "_to_local will be made private in a future version."
      time.in_time_zone(self.time_zone)
    end
    
    # Given a string that looks like a time. It will convert that string into a time object that matches the time but with
    # the instances time zone appended.
    def _add_zone(time_string)
      ActiveSupport::Deprecation.warn "_add_zone will be made private in a future version."
      Time.zone = self.time_zone
      Time.zone.parse(time_string)
    end

    # Returns a string representation of a time object suitable for consumption by add_zone.
    def _change_zone(time)
      ActiveSupport::Deprecation.warn "_change_zone will be made private in a future version."
      _add_zone(time.strftime('%a, %d %b %Y %H:%M:%S'))
    end
  end
end
