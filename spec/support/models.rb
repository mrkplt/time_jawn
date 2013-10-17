class Happening < ActiveRecord::Base
end

class Event < ActiveRecord::Base
  has_time_zone   :t_z
end