module TimeJawn
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def has_time_zone
      send :include, InstanceMethods
    end

    def datetime_attributes
      klass = self.name.constantize

      datetime_attributes = []
      klass.columns_hash.each do |column|
         datetime_attributes << (column[0]).to_sym if column[1].type == :datetime
      end
      return datetime_attributes
    end
  end

  module InstanceMethods
    def self.included(base)
      base.datetime_attributes.each do |attribute|
        define_method("local_" + attribute.to_s) { to_local(send(attribute)) }
      end
      base.datetime_attributes.each do |attribute|
        define_method("local_" + attribute.to_s + '=') do |time_or_string_value|
          if time_or_string_value.class.name == 'String'
            write_attribute(attribute, add_zone(time_or_string_value))
          else
            write_attribute(attribute, change_zone(time_or_string_value))
          end
        end
      end
    end

    def current_time
      to_local(DateTime.current)
    end

    def to_local(time)
      time.in_time_zone(self.time_zone)
    end
  
    def add_zone(time_string)
      Time.zone = self.time_zone
      Time.zone.parse(time_string)
    end

    def change_zone(time)
      add_zone(time.strftime('%a, %d %b %Y %H:%M:%S'))
    end
  end
end
