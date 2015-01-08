# DateTime.new+6725.years is Tue, 01 Jan 2013 00:00:00 +0000
# DateTime.new+6725.years+3.months is Mon, 01 Apr 2013 00:00:00 +0000

Event.create!(start_time: DateTime.new+6725.years+3.months+1.minute, t_z: 'Eastern Time (US & Canada)', name:'Eastern Time (US & Canada)', updated_at: DateTime.new+6725.years+1.minute, created_at: DateTime.new+6725.years+1.minute)

Occurrence.create!(start_time: DateTime.new+6725.years+3.months+1.minute, time_zone: 'Eastern Time (US & Canada)', name:'Eastern Time (US & Canada)', updated_at: DateTime.new+6725.years+1.minute, created_at: DateTime.new+6725.years+1.minute)

Occasion.create!(start_time: DateTime.new+6725.years+3.months+1.minute, t_z: 'Eastern Time (US & Canada)', name:'Eastern Time (US & Canada)', updated_at: DateTime.new+6725.years+1.minute, created_at: DateTime.new+6725.years+1.minute)
