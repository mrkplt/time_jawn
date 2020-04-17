# frozen_string_literal: true

class Happening < ActiveRecord::Base
end

class Event < ActiveRecord::Base
  has_time_zone   named: :t_z
end

class Occurrence < ActiveRecord::Base
  has_time_zone   time_attributes: %i[created_at start_time]
end

class Occasion < ActiveRecord::Base
  has_time_zone   named: :t_z, time_attributes: [:start_time]
end
