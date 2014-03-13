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
    datetime_attributes
  end

  private

  def _set_instance_variables(options_hash)
    @time_zone_attribute_name = options_hash.fetch(:named, :time_zone)
    @time_jawn_date_time_attributes = options_hash.fetch(:time_attributes, nil)
  end

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

  # returns all of the date_time attributes for a class unless it is specified in the class.
  def _class_date_attributes_or_arguments
    @time_jawn_date_time_attributes || _datetime_attributes
  end
end
