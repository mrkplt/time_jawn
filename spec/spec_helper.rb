require 'active_record'
require 'timecop'
require 'time_jawn'

Time.zone = 'UTC'

ActiveRecord::Base.default_timezone = 'UTC'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3",
                                        :database => File.dirname(__FILE__) + "/time_jawn.sqlite3")

load File.dirname(__FILE__) + '/support/schema.rb'
load File.dirname(__FILE__) + '/support/models.rb'
load File.dirname(__FILE__) + '/support/data.rb'
