require 'spec_helper'

describe Happening do
  before(:each){
      @happening1 = Happening.find_by_name('Eastern Time (US & Canada)')
      @happening2 = Happening.find_by_name('Pacific/Honolulu')
      Time.zone = 'UTC'
  }
  context 'class method' do
    describe "datetime_attributes" do
      it "returns an array of all datetime objects for the class" do
        expect(Happening.datetime_attributes).to eq [:start_time, :created_at, :updated_at] 
      end
    end
    describe "has_time_zone" do
      it "does not have instance methods until called" do
        expect(Happening.instance_methods.include? :local_start_time).to eq false
        expect(Happening.instance_methods.include? :local_created_at).to eq false
        expect(Happening.instance_methods.include? :local_updated_at).to eq false
      end
      it "has instance methods once called " do
        
        Happening.has_time_zone
        
        expect(Happening.instance_methods.include? :local_start_time).to eq true
        expect(Happening.instance_methods.include? :local_created_at).to eq true
        expect(Happening.instance_methods.include? :local_updated_at).to eq true
      end
    end
  end
  context 'static instance methods' do

    describe "self.included(base)" do
      pending "How do you test this? I suppose if the dynamic tests exist this worked. Seems shoddy."
    end

    describe "current_time" do
      it "returns a time with zone object reflecting the current local time of the instance"
    end

    describe "to_local(time)" do
      it "returns a time with zone that has been coverted to reflect the local time" do
        expect(@happening1.start_time).to eq 'Mon, 01 Apr 2013 00:01:00 UTC +00:00'
        expect(@happening1.to_local(@happening1.start_time)).to eq 'Sun, 31 Mar 2013 20:01:00 EDT -04:00'
        expect(@happening1.to_local(@happening1.start_time).to_s).to eq "2013-03-31 20:01:00 -0400"
      end
    end

    describe "add_zone(time_string)" do
      it "returns a time with zone object that reflects the time value passed in time_string with time zone information of instance appended" do

        expect(@happening1.add_zone("2013-08-19 12:34:56")).to eq 'Mon, 19 Aug 2013 12:34:56 EDT -04:00'
        expect(@happening2.add_zone("2013-08-19 12:34:56")).to eq 'Mon, 19 Aug 2013 12:34:56 HST -10:00'
        expect(@happening1.add_zone("2013-11-11 12:34:56")).to eq 'Mon, 11 Nov 2013 12:34:56 EST -05:00'
        expect(@happening2.add_zone("2013-11-11 12:34:56")).to eq 'Mon, 11 Nov 2013 12:34:56 HST -10:00'
     
      end
    end

    describe "change_zone(time)" do
      it "returns a time with zone object that has had only it's time zone switched to local time of instance"
    end
  end
  context 'dynamic instance methods' do
    describe "local_start_time" do
      it "returns a time with zone object that reflects the value of start_time altered to the instance's time zone" do
        expect(@happening1.start_time).to eq 'Mon, 01 Apr 2013 00:01:00 UTC +00:00'
        expect(@happening1.start_time).to eq 'Sun, 31 Mar 2013 20:01:00 EDT -04:00'
        Time.zone = 'Eastern Time (US & Canada)'
        expect(@happening1.local_start_time.to_s).to eq "2013-03-31 20:01:00 -0400"

        expect(@happening2.start_time).to eq 'Mon, 01 Apr 2013 00:00:00 UTC +00:00'
        expect(@happening2.start_time).to eq 'Sun, 31 Mar 2013 14:00:00 HST -10:00'
        Time.zone = 'Pacific/Honolulu'
        expect(@happening2.local_start_time.to_s).to eq "2013-03-31 14:00:00 -1000"
      end
    end

    describe "local_updated_at" do
      it "returns a time with zone object that reflects the value of updated_at at altered to the instance's time zone" do
        expect(@happening1.updated_at).to eq 'Tue, 01 Jan 2013 00:01:00 UTC +0000'
        expect(@happening1.updated_at).to eq 'Wed, 31 Dec 2012 20:01:00 EDT -04:00'
        Time.zone = 'Eastern Time (US & Canada)'
        expect(@happening1.local_updated_at.to_s).to eq "2012-12-31 19:01:00 -0500"

        expect(@happening2.updated_at).to eq 'Tue, 01 Jan 2013 00:00:00 UTC +0000'
        expect(@happening2.updated_at).to eq 'Wed, 31 Dec 2012 14:00:00 HST -10:00'
        Time.zone = 'Pacific/Honolulu'
        expect(@happening2.local_updated_at.to_s).to eq "2012-12-31 14:00:00 -1000"
      end
    end

    describe "local_created_at" do
      it "returns a time with zone object that reflects the value of created_at at altered to the instance's time zone" do
        expect(@happening1.created_at).to eq 'Tue, 01 Jan 2013 00:01:00 UTC +0000'
        expect(@happening1.created_at).to eq 'Wed, 31 Dec 2012 20:01:00 EDT -04:00'
        Time.zone = 'Eastern Time (US & Canada)'
        expect(@happening1.local_created_at.to_s).to eq "2012-12-31 19:01:00 -0500"

        expect(@happening2.created_at).to eq 'Tue, 01 Jan 2013 00:00:00 UTC +0000'
        expect(@happening2.created_at).to eq 'Wed, 31 Dec 2012 14:00:00 HST -10:00'
        Time.zone = 'Pacific/Honolulu'
        expect(@happening2.local_created_at.to_s).to eq "2012-12-31 14:00:00 -1000"
      end
    end
  end
end
