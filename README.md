TimeJawn v2.0.1
========
[![Code Climate](https://codeclimate.com/github/mrkplt/time_jawn/badges/gpa.svg)](https://codeclimate.com/github/mrkplt/time_jawn)


TimeJawn makes class instances time zone aware. It doesn't care one iota about system, application or database time.

Usage
--------------
```
gem install time_jawn
```

TimeJawn expects there to be an attribute on the model called time_zone, and that the attribute be present, and valid. TimeJawn works fine with delegations. If you do not have an attribute called time_zone you can add one:

```
rails g migration AddTimeZoneToModel time_zone:string
```

Next, add the following line to your model:

```
has_time_zone
```

If you already have a time zone attribute on your class, but it is not named time_zone you can specify it's name.

```
has_time_zone named: :my_whacky_time_zone
```

If you would like to specify specific date_time attributes that you would like affected you can do so like this.

```
has_time_zone   time_attributes: [:created_at, :start_time]
```

Finally, you can also specify a time zone attribute and control the affected attributes.

```
has_time_zone     named: :my_whacky_time_zone,
                  time_attributes: [:created_at, :start_time]
```

At this point when you create a new instance of that model you will get two methods for each datetime attribute. One that will convert the time stored in the database into the local time of the instance, and one that will convert any time presented to it into a localized version of that time (which is to say, any time zone info will be stripped off, and the objects time zone will be appended). That can be confusing so here are some examples (that we are going to assume have a time zone attribute already):

```
class GenericClass < ActiveRecord::Base
  has_time_zone
end

DateTime.now
# Mon, 30 Sep 2013 13:02:19 -0400

instance_of_class = GenericClass.new(time_zone: 'Arizona', created_at: DateTime.now, updated_at: DateTime.now)

instance_of_class.local_created_at
# Mon, 30 Sep 2013 10:02:41 MST -07:00

instance_of_class.local_updated_at
# Mon, 30 Sep 2013 10:02:41 MST -07:00

instance_of_class.current_time
# Mon, 30 Sep 2013 10:04:01 MST -07:00

instance_of_class.local_updated_at = DateTime.now
# Mon, 30 Sep 2013 13:07:00 -0400

instance_of_class.local_updated_at
# Mon, 30 Sep 2013 13:07:00 MST -07:00 - Time zone info completely replaced
```

At some point you may want to add a field to a form so you can easily set the time zone. ActiveSupport makes that pretty easy:

```
= f.label :time_zone, "Time Zone: "
= f.time_zone_select(:time_zone, ActiveSupport::TimeZone.us_zones)
```

Resources
---------

This is not everything I used to figure out how to write this gem, but it's a solid sample.

Time:

 - http://danilenko.org/2012/7/6/rails_timezones/
 - http://www.elabs.se/blog/36-working-with-time-zones-in-ruby-on-rails
 - http://api.rubyonrails.org/classes/ActiveSupport/TimeZone.html
 - http://apidock.com/rails/v3.2.13/ActionView/Helpers/FormOptionsHelper/time_zone_select

Gem:

 - http://guides.rubygems.org/patterns/
 - http://ryanbigg.com/2011/01/extending-active-record/
 - http://danieltsadok.wordpress.com/2010/04/06/understanding-rails-plugins/
 - http://blog.firsthand.ca/2010/09/ruby-rdoc-example.html

Other:

- http://rubymonk.com/learning/books/2-metaprogramming-ruby/chapters/25-dynamic-methods/lessons/72-define-method

License
-------
TimeJawn is Copyright © 2020 Mark Platt and Tamman Technologies, Inc. It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.
