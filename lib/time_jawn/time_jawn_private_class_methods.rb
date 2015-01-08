# Defines private methods necessary for TimeJawn to work.
module TimeJawnPrivateClassMethods

  private

  # Locates all of an ActiveRecord class' DateTime Attributes and returns them as an array of symbols.
  def datetime_attributes
    name.constantize.columns.map do |column|
       next unless column.type == :datetime
       column.name.to_sym
    end.compact
  end

  def set_instance_variables(options_hash)
    @time_zone_attribute_name = options_hash.fetch(:named, :time_zone)
    @time_jawn_date_time_attributes = options_hash.fetch(:time_attributes, nil)
  end

  # generates an instance method called "local_#{attribute}" that calls the _to_local instance method.
  def generate_to_local(attribute)
    define_method(:"local_#{attribute}") { to_local(send(attribute)) }
  end

  # generates an instance method called "local_#{attribute}=" that calls either the _add_zone or _change_zone
  # instance methods depending on teh class of the input.
  def generate_to_local_with_assignment(attribute)
    define_method(:"local_#{attribute}=") do |time_or_string_value|
      if time_or_string_value.is_a? String
        write_attribute(attribute, add_zone(time_or_string_value))
      else
        write_attribute(attribute, change_zone(time_or_string_value))
      end
    end
  end

  # returns all of the date_time attributes for a class unless it is specified in the class.
  def class_date_attributes_or_arguments
    @time_jawn_date_time_attributes || datetime_attributes
  end
end
