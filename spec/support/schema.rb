ActiveRecord::Schema.define do
  self.verbose = false

  create_table :happenings, :force => true do |t|
    t.string "name"
    t.datetime "start_time"
    t.string   "time_zone"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end
  create_table :events, :force => true do |t|
    t.string "name"
    t.datetime "start_time"
    t.string   "t_z"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end
  create_table :occurrences, :force => true do |t|
    t.string "name"
    t.datetime "start_time"
    t.string   "time_zone"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end
  create_table :occasions, :force => true do |t|
    t.string "name"
    t.datetime "start_time"
    t.string   "t_z"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end
end
