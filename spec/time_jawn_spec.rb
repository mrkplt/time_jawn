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
  context 'static instance methods' do
    before{
      @happening = Happening.find.last
    }
    describe "self.included(base)" do
      pending "How do you test this? I suppose if the dynamic tests exist this worked. Seems shoddy."
    end

    describe "current_time" do
      pending "Test Incoming"
    end

    describe "to_local(time)" do
      pending "Test Incoming"
    end

    describe "add_zone(time)" do
      pending "Test Incoming"
    end

    describe "change_zone(time)" do
      pending "Test Incoming"
    end
  end
  context 'dynamic instance methods' do
    describe "created_at_local_time" do
      pending "Test Incoming"
    end

    describe "updated_at_local_time" do
      pending "Test Incoming"
    end

    describe "start_time_local_time" do
      pending "Test Incoming"
    end
  end
end
