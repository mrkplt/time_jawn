# The base module of the TimeJawn gem. Everything in here assumes that your
# model has a valid time zone in a attribute name time_zone or has been
# delegating one to somewhere else.
module TimeJawn
  require 'time_jawn/time_jawn_private_class_methods'

  DATE_FORMAT = '%a, %d %b %Y %H:%M:%S'

  # Automatically runs and adds ClassMethods to ActiveRecord::Base
  def self.included(base)
    base.send :extend, ClassMethods
  end

  # Defines methods that will attached to all ActiveRecord classes.
  module ClassMethods
    include TimeJawnPrivateClassMethods
    attr_reader :time_zone_attribute_name
    # When called it loads the methods located in InstanceMethods.
    # It is typically included in a model's rb file so that instances of that
    # class gain the InstanceMethods at each instantiation.
    #     class Event<ActiveRecord::Base
    #       has_time_zone
    #     end
    # Optionally you may pass the name of your time zone attribute in as a
    # symbol.
    #     class Event<ActiveRecord::Base
    #       has_time_zone   named: :this_is_my_time_zone
    #     end
    def has_time_zone(options_hash={})
      set_instance_variables(options_hash)
      send(:include, InstanceMethods)
    end
  end

  #Defines methods that will be added to instances of classes that have
  # previously called has_time_zone.
  module InstanceMethods
    # This method generates a series of methods on instances by calling the
    # enerate_to_local and generate_to_local_with_assignment that are private on
    # the parent class. The methods that are created are called
    # local_#{attribue} and local_#{attribute}= the attribute portion their
    # names are completed by enumerating the datetime_attributes of the class.
    # Twice as many methods as there are DateTime attributes will be created.
    #
    #    :created_at, and :updated_at
    #
    #     local_created_at
    #     local_updated_at
    #     local_created_at=
    #     local_updated_at=
    #
    # The local_#{attribue} methods will take the value stored in the attribute
    # indicated by the methods name and apply a time zone conversion to it. This
    #  is useful for displaying the local time (according to the object).
    #
    # local_#{attribute}= methods are assignment shortcuts. They behave a little
    # differently than you would expect. They do not take a local time and
    # convert it into utc (or whatever, ActiveSupport will handle that for us),
    # what these assigment methods do is take any sort of string that looks like
    # a time, or any sort of time or datetime object lop off whatever timezone
    # is being fed in and glue the instances local timezone on the end before
    # applying it to the appropriate attribute. This is convenient for some one
    # in one time zone setting a value for an instance that represents a
    # different time zone. For example:
    #
    #     I am in Philadelphia (EST), my application is set to UTC, and I want
    #     to set the time on an Alarm instance that  goes off in San Francisco
    #     (PST). I want that time to be 6PM. In Philadlephia I choose 6PM
    #     (local), the applications assumes I meant 6PM UTC (2PM EST and 11AM
    #     PST). That is not what I intended, I intended on 6PM PST, and now my
    #     Alarm is all wrong. The assignment methods turn 6PM (set in EST, and
    #     processed in UTC) into 6PM PST (or 9PM EST, 1AM UTC) the expected
    #     time. The Alarm goes off as expected!*
    #
    #     *Times in this example may be wrong since I put them in myself.
    #
    # You can see examples of how these methods work in the specs folder.
    def self.included(base)
      date_time_attributes = base.send(:class_date_attributes_or_arguments)
      date_time_attributes.each do |attribute|
        base.send(:generate_to_local, attribute)
        base.send(:generate_to_local_with_assignment, attribute)
      end
    end

    # Returns the current time according to the instance.
    def current_time
      to_local(DateTime.current)
    end

    private

    # converts a time object into it's local counter part (they will have the
    # same value but differnt presentation.)
    def to_local(time)
      time.in_time_zone(self.send(self.class.time_zone_attribute_name))
    end

    # Given a string that looks like a time. It will convert that string into a
    # time object that matches the time but with the instances time zone
    # appended.
    def add_zone(time_string)
      Time.zone = self.send(self.class.time_zone_attribute_name)
      Time.zone.parse(Time.parse(time_string).strftime(DATE_FORMAT))
    end

    # Returns a string representation of a time object suitable for consumption
    # by add_zone.
    def change_zone(time)
      add_zone(time.strftime(DATE_FORMAT))
    end
  end
end
