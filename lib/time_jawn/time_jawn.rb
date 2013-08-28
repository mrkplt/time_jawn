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
         datetime_attributes << (column[0]) if column[1].type == :datetime
      end
      return datetime_attributes
    end
  end

  module InstanceMethods
    
    def self.included(base)
      base.datetime_attributes.each do |attribute|
        define_method("#{attribute}_local_time") { to_local(send(attribute.to_sym)) }
      end
    end

    def current_time
      to_local(DateTime.current)
    end

    def to_local(time)
      time.in_time_zone(self.time_zone)
    end
  
    def add_zone(time)
      Time.zone = self.time_zone
      Time.zone.parse(time)
    end

    def change_zone(time)
      Time.zone = self.time_zone
      Time.zone.parse(time.to_s)
    end
  end
end
