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
        expect(Happening._datetime_attributes).to eq [:start_time, :created_at, :updated_at] 
      end
    end
    describe "has_time_zone" do
      it "does not have instance methods until called" do
        expect(Happening.instance_methods.include? :local_start_time).to eq false
        expect(Happening.instance_methods.include? :local_created_at).to eq false
        expect(Happening.instance_methods.include? :local_updated_at).to eq false
        expect(Happening.instance_methods.include? :local_start_time=).to eq false
        expect(Happening.instance_methods.include? :local_updated_at=).to eq false
        expect(Happening.instance_methods.include? :local_updated_at=).to eq false
      end
      it "has instance methods once called " do
        
        Happening.has_time_zone
        
        expect(Happening.instance_methods.include? :local_start_time).to eq true
        expect(Happening.instance_methods.include? :local_created_at).to eq true
        expect(Happening.instance_methods.include? :local_updated_at).to eq true
        expect(Happening.instance_methods.include? :local_start_time=).to eq true
        expect(Happening.instance_methods.include? :local_created_at=).to eq true
        expect(Happening.instance_methods.include? :local_updated_at=).to eq true
      end
    end
  end
  context 'static instance methods' do

    describe "self.included(base)" do
      pending "How do you test this? I suppose if the dynamic tests exist this worked. Seems shoddy."
    end

    describe "current_time" do
      it "returns a time with zone object reflecting the current local time of the instance" do
        Timecop.freeze
        expect(DateTime.current).to eq @happening1.current_time
        Timecop.return
      end
    end

    describe "_to_local(time)" do
      it "returns a time with zone that has been coverted to reflect the local time" do
        expect(@happening1.start_time).to eq 'Mon, 01 Apr 2013 00:01:00 UTC +00:00'
        expect(@happening1._to_local(@happening1.start_time)).to eq 'Sun, 31 Mar 2013 20:01:00 EDT -04:00'
        expect(@happening1._to_local(@happening1.start_time).to_s).to eq "2013-03-31 20:01:00 -0400"
      end
    end

    describe "_add_zone(time_string)" do
      it "returns a time with zone object that reflects the time value passed in time_string with time zone information of instance appended" do
        expect(@happening1._add_zone("2013-08-19 12:34:56")).to eq 'Mon, 19 Aug 2013 12:34:56 EDT -04:00'
        expect(@happening2._add_zone("2013-08-19 12:34:56")).to eq 'Mon, 19 Aug 2013 12:34:56 HST -10:00'
        expect(@happening1._add_zone("2013-11-11 12:34:56")).to eq 'Mon, 11 Nov 2013 12:34:56 EST -05:00'
        expect(@happening2._add_zone("2013-11-11 12:34:56")).to eq 'Mon, 11 Nov 2013 12:34:56 HST -10:00'
      end
    end

    describe "_change_zone(time)" do
      it "returns a time with zone object that has had only it's time zone switched to local time of instance" do
        Time.zone = 'Rangoon'
        time = Time.zone.parse("Wed, 28 Aug 2015 15:16:16")
        expect(time.to_s.split(' ')[2]).to eq ('+0630')
        expect(time.to_s.split(' ')[2]).to_not eq ('-0400')
        expect(@happening1._change_zone(time)).to_not eq time
        expect(@happening1._change_zone(time).to_s.split(' ')[0]).to eq time.to_s.split(' ')[0]
        expect(@happening1._change_zone(time).to_s.split(' ')[1]).to eq time.to_s.split(' ')[1]
        expect(@happening1._change_zone(time).to_s.split(' ')[2]).to_not eq time.to_s.split(' ')[2]
        expect(@happening1._change_zone(time).to_s.split(' ')[2]).to_not eq ('+0630')
        expect(@happening1._change_zone(time).to_s.split(' ')[2]).to eq ('-0400')
      end
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

    describe "local_start_time=(time_or_string)" do
      it "sets start_time on the instance to a time_with_zone object only modifying the time zone" do
        expect(@happening1.start_time).to eq 'Mon, 01 Apr 2013 00:01:00 UTC +00:00'
        
        @happening1.local_start_time = Time.parse("Thu, 29 Aug 2013 02:40:12 HST -10:00")
        expect(@happening1.start_time).to eq Time.parse("2013-08-29 02:40:12 -0400")

        @happening1.local_start_time = Time.parse("Thu, 29 Aug 2013 02:41:12")
        expect(@happening1.start_time).to eq Time.parse("2013-08-29 02:41:12 -0400")

        @happening1.local_start_time = "Thu, 29 Aug 2013 02:42:12"
        expect(@happening1.start_time).to eq Time.parse("2013-08-29 02:42:12 -0400")

        @happening1.local_start_time = "Thu, 29 Aug 2013 02:43:12 HST -10:00"
        expect(@happening1.start_time).to eq Time.parse("2013-08-29 02:43:12 -0400")

        @happening1.local_start_time = "2013-11-11 12:34:56"
        expect(@happening1.start_time).to eq Time.parse("2013-11-11 12:34:56 -0500")

      end
    end

    describe "local_updated_at=(time_or_string)" do
      it "sets updated_at on the instance to a time_with_zone object only modifying the time zone" do
        expect(@happening1.updated_at).to eq 'Tue, 01 Jan 2013 00:01:00 +0000'
        
        @happening1.local_updated_at = Time.parse("Thu, 29 Aug 2013 02:40:12 HST -10:00")
        expect(@happening1.updated_at).to eq Time.parse("2013-08-29 02:40:12 -0400")

        @happening1.local_updated_at = Time.parse("Thu, 29 Aug 2013 02:41:12")
        expect(@happening1.updated_at).to eq Time.parse("2013-08-29 02:41:12 -0400")

        @happening1.local_updated_at = "Thu, 29 Aug 2013 02:42:12"
        expect(@happening1.updated_at).to eq Time.parse("2013-08-29 02:42:12 -0400")

        @happening1.local_updated_at = "Thu, 29 Aug 2013 02:43:12 HST -10:00"
        expect(@happening1.updated_at).to eq Time.parse("2013-08-29 02:43:12 -0400")

        @happening1.local_updated_at = "2013-11-11 12:34:56"
        expect(@happening1.updated_at).to eq Time.parse("2013-11-11 12:34:56 -0500")

      end
    end

    describe "local_created_at=(time_or_string)" do
      it "sets created_at on the instance to a time_with_zone object only modifying the time zone" do
        expect(@happening1.created_at).to eq ' Tue, 01 Jan 2013 00:01:00 +0000'
        
        @happening1.local_created_at = Time.parse("Thu, 29 Aug 2013 02:40:12 HST -10:00")
        expect(@happening1.created_at).to eq Time.parse("2013-08-29 02:40:12 -0400")

        @happening1.local_created_at = Time.parse("Thu, 29 Aug 2013 02:41:12")
        expect(@happening1.created_at).to eq Time.parse("2013-08-29 02:41:12 -0400")

        @happening1.local_created_at = "Thu, 29 Aug 2013 02:42:12"
        expect(@happening1.created_at).to eq Time.parse("2013-08-29 02:42:12 -0400")

        @happening1.local_created_at = "Thu, 29 Aug 2013 02:43:12 HST -10:00"
        expect(@happening1.created_at).to eq Time.parse("2013-08-29 02:43:12 -0400")

        @happening1.local_created_at = "2013-11-11 12:34:56"
        expect(@happening1.created_at).to eq Time.parse("2013-11-11 12:34:56 -0500")

      end
    end
  end
end

describe Event do
  before do
    @event1 = Event.find_by_name('Eastern Time (US & Canada)')
  end
  context "Event should have time_jawn methods even though it has a non_conventional attribute" do
    subject { @event1 }

    it { should respond_to :local_start_time }
    it { should respond_to :local_created_at }
    it { should respond_to :local_updated_at }
    it { should respond_to :local_start_time= }
    it { should respond_to :local_created_at= }
    it { should respond_to :local_updated_at= }
    it { should respond_to :current_time }
    it { should respond_to :_to_local }
    it { should respond_to :_add_zone }
    it { should respond_to :_change_zone }
  end
end

describe Occurrence do
  before do
    @occurrence1 = Occurrence.find_by_name('Eastern Time (US & Canada)')
  end
  
  context "Ocurrence instance attribute accessor" do
    describe "time_zone_attribute_name" do
      it 'should respond with the time_zone attribute name as defined in the class.' do
        expect( @occurrence1.class.time_zone_attribute_name ).to eq :time_zone
      end
    end
  end

  context "Occurrence should have time_jawn methods, except for local_updated_at, since it is not specified in the model" do
    subject { @occurrence1 }

    it { should respond_to :local_start_time }
    it { should respond_to :local_created_at }
    it { should_not respond_to :local_updated_at }
    it { should respond_to :local_start_time= }
    it { should respond_to :local_created_at= }
    it { should_not respond_to :local_updated_at= }
    it { should respond_to :current_time }
    it { should respond_to :_to_local }
    it { should respond_to :_add_zone }
    it { should respond_to :_change_zone }
  end
end

describe Occasion do
  before do
    @occasion1 = Occasion.find_by_name('Eastern Time (US & Canada)')
  end

  context "Occasion instance attribute accessor" do
    describe "time_zone_attribute_name" do
      it 'should respond with the time_zone attribute name as defined in the class.' do
        expect( @occasion1.class.time_zone_attribute_name ).to eq :t_z
      end
    end
  end

  context "Occasion should have time_jawn methods, except for local_updated_at, since it is not specified in the model, even though it has a non_conventional attribute" do
    subject { @occasion1 }

    it { should respond_to :local_start_time }
    it { should_not respond_to :local_created_at }
    it { should_not respond_to :local_updated_at }
    it { should respond_to :local_start_time= }
    it { should_not respond_to :local_created_at= }
    it { should_not respond_to :local_updated_at= }
    it { should respond_to :current_time }
    it { should respond_to :_to_local }
    it { should respond_to :_add_zone }
    it { should respond_to :_change_zone }
  end
end
