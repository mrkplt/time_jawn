require 'spec_helper'

describe Happening do
  context 'class method' do
    describe "datetime_attributes" do
      it "returns an array of all datetime objects for the class" do
        expect(Happening.datetime_attributes).to eq ["start_time", "created_at", "updated_at"] 
      end
    end
    describe "has_time_zone" do
      it "does not have instance methods until called" do
        expect(Happening.instance_methods.include? :start_time_local_time).to eq false
        expect(Happening.instance_methods.include? :created_at_local_time).to eq false
        expect(Happening.instance_methods.include? :updated_at_local_time).to eq false
      end
      it "has instance methods once called " do
        
        Happening.has_time_zone
        
        expect(Happening.instance_methods.include? :start_time_local_time).to eq true
        expect(Happening.instance_methods.include? :created_at_local_time).to eq true
        expect(Happening.instance_methods.include? :updated_at_local_time).to eq true
      end
    end
  end
  context 'instance methods' do
    before{
      @happening = Happening.find.last
    }
  end
end