TimeJawn


```
rails g migration AddTimeZoneToModel time_zone:string
```

```
add_time_zone
```

```
= f.label :time_zone, "Time Zone: "
= f.time_zone_select(:time_zone, ActiveSupport::TimeZone.us_zones)
```

Resources:

http://danilenko.org/2012/7/6/rails_timezones/

http://www.elabs.se/blog/36-working-with-time-zones-in-ruby-on-rails

http://guides.rubygems.org/patterns/

http://ryanbigg.com/2011/01/extending-active-record/

http://danieltsadok.wordpress.com/2010/04/06/understanding-rails-plugins/

http://rubymonk.com/learning/books/2-metaprogramming-ruby/chapters/25-dynamic-methods/lessons/72-define-method

http://blog.firsthand.ca/2010/09/ruby-rdoc-example.html

http://apidock.com/rails/v3.2.13/ActionView/Helpers/FormOptionsHelper/time_zone_select

http://api.rubyonrails.org/classes/ActiveSupport/TimeZone.html