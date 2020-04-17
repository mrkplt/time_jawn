# frozen_string_literal: true

require 'spec_helper'

describe Happening do
  before(:each) do
    @happening1 =
      Happening.new(
        start_time: DateTime.new + 6725.years + 3.months + 1.minute,
        time_zone: 'Eastern Time (US & Canada)',
        name: 'Eastern Time (US & Canada)',
        updated_at: DateTime.new + 6725.years + 1.minute,
        created_at: DateTime.new + 6725.years + 1.minute
      )

    @happening2 =
      Happening.new(
        start_time: DateTime.new + 6725.years + 3.months,
        time_zone: 'Pacific/Honolulu', name: 'Pacific/Honolulu',
        updated_at: DateTime.new + 6725.years,
        created_at: DateTime.new + 6725.years
      )

    Time.zone = 'UTC'
  end

  context 'class method' do
    describe 'has_time_zone' do
      it 'does not have instance methods until called' do
        expect(Happening.instance_methods.include?(:local_start_time))
          .to eq false

        expect(Happening.instance_methods.include?(:local_created_at))
          .to eq false

        expect(Happening.instance_methods.include?(:local_updated_at))
          .to eq false

        expect(Happening.instance_methods.include?(:local_start_time=))
          .to eq false

        expect(Happening.instance_methods.include?(:local_updated_at=))
          .to eq false

        expect(Happening.instance_methods.include?(:local_updated_at=))
          .to eq false
      end
      it 'has instance methods once called ' do
        Happening.has_time_zone

        expect(Happening.instance_methods.include?(:local_start_time))
          .to eq true

        expect(Happening.instance_methods.include?(:local_created_at))
          .to eq true

        expect(Happening.instance_methods.include?(:local_updated_at))
          .to eq true

        expect(Happening.instance_methods.include?(:local_start_time=))
          .to eq true

        expect(Happening.instance_methods.include?(:local_created_at=))
          .to eq true

        expect(Happening.instance_methods.include?(:local_updated_at=))
          .to eq true
      end
    end
  end

  context 'static instance methods' do
    describe 'current_time' do
      it 'returns a time with zone object reflecting the current local time of the instance' do
        Timecop.freeze
        expect(DateTime.current).to eq @happening1.current_time
        Timecop.return
      end
    end
  end

  context 'dynamic instance methods' do
    describe 'local_start_time' do
      it "returns a time with zone object that reflects the value of start_time altered to the instance's time zone" do
        expect(@happening1.start_time)
          .to eq 'Mon, 01 Apr 2013 00:01:00 UTC +00:00'

        expect(@happening1.start_time)
          .to eq 'Sun, 31 Mar 2013 20:01:00 EDT -04:00'

        Time.zone = 'Eastern Time (US & Canada)'

        expect(@happening1.local_start_time.to_s)
          .to eq '2013-03-31 20:01:00 -0400'

        expect(@happening2.start_time)
          .to eq 'Mon, 01 Apr 2013 00:00:00 UTC +00:00'

        expect(@happening2.start_time)
          .to eq 'Sun, 31 Mar 2013 14:00:00 HST -10:00'

        Time.zone = 'Pacific/Honolulu'

        expect(@happening2.local_start_time.to_s)
          .to eq '2013-03-31 14:00:00 -1000'
      end
    end

    describe 'local_updated_at' do
      it "returns a time with zone object that reflects the value of updated_at at altered to the instance's time zone" do
        expect(@happening1.updated_at)
          .to eq 'Tue, 01 Jan 2013 00:01:00 UTC +0000'

        expect(@happening1.updated_at)
          .to eq 'Wed, 31 Dec 2012 20:01:00 EDT -04:00'

        Time.zone = 'Eastern Time (US & Canada)'

        expect(@happening1.local_updated_at.to_s)
          .to eq '2012-12-31 19:01:00 -0500'

        expect(@happening2.updated_at)
          .to eq 'Tue, 01 Jan 2013 00:00:00 UTC +0000'
        expect(@happening2.updated_at)
          .to eq 'Wed, 31 Dec 2012 14:00:00 HST -10:00'
        Time.zone = 'Pacific/Honolulu'

        expect(@happening2.local_updated_at.to_s)
          .to eq '2012-12-31 14:00:00 -1000'
      end
    end

    describe 'local_created_at' do
      it "returns a time with zone object that reflects the value of created_at at altered to the instance's time zone" do
        expect(@happening1.created_at)
          .to eq 'Tue, 01 Jan 2013 00:01:00 UTC +0000'

        expect(@happening1.created_at)
          .to eq 'Wed, 31 Dec 2012 20:01:00 EDT -04:00'

        Time.zone = 'Eastern Time (US & Canada)'

        expect(@happening1.local_created_at.to_s)
          .to eq '2012-12-31 19:01:00 -0500'

        expect(@happening2.created_at)
          .to eq 'Tue, 01 Jan 2013 00:00:00 UTC +0000'

        expect(@happening2.created_at)
          .to eq 'Wed, 31 Dec 2012 14:00:00 HST -10:00'

        Time.zone = 'Pacific/Honolulu'

        expect(@happening2.local_created_at.to_s)
          .to eq '2012-12-31 14:00:00 -1000'
      end
    end

    describe 'local_start_time=(time_or_string)' do
      it 'sets start_time on the instance to a time_with_zone object only modifying the time zone' do
        expect(@happening1.start_time)
          .to eq 'Mon, 01 Apr 2013 00:01:00 UTC +00:00'

        @happening1.local_start_time = Time.parse('Thu, 29 Aug 2013 02:40:12 HST -10:00')
        expect(@happening1.start_time)
          .to eq Time.parse('2013-08-29 02:40:12 -0400')

        @happening1.local_start_time = Time.parse('Thu, 29 Aug 2013 02:41:12')
        expect(@happening1.start_time)
          .to eq Time.parse('2013-08-29 02:41:12 -0400')

        @happening1.local_start_time = 'Thu, 29 Aug 2013 02:42:12'
        expect(@happening1.start_time)
          .to eq Time.parse('2013-08-29 02:42:12 -0400')

        @happening1.local_start_time = 'Thu, 29 Aug 2013 02:43:12 HST -10:00'
        expect(@happening1.start_time)
          .to eq Time.parse('2013-08-29 02:43:12 -0400')

        @happening1.local_start_time = '2013-11-11 12:34:56'
        expect(@happening1.start_time)
          .to eq Time.parse('2013-11-11 12:34:56 -0500')
      end
    end

    describe 'local_updated_at=(time_or_string)' do
      it 'sets updated_at on the instance to a time_with_zone object only modifying the time zone' do
        expect(@happening1.updated_at)
          .to eq 'Tue, 01 Jan 2013 00:01:00 +0000'

        @happening1.local_updated_at = Time.parse('Thu, 29 Aug 2013 02:40:12 HST -10:00')
        expect(@happening1.updated_at)
          .to eq Time.parse('2013-08-29 02:40:12 -0400')

        @happening1.local_updated_at = Time.parse('Thu, 29 Aug 2013 02:41:12')
        expect(@happening1.updated_at)
          .to eq Time.parse('2013-08-29 02:41:12 -0400')

        @happening1.local_updated_at = 'Thu, 29 Aug 2013 02:42:12'
        expect(@happening1.updated_at)
          .to eq Time.parse('2013-08-29 02:42:12 -0400')

        @happening1.local_updated_at = 'Thu, 29 Aug 2013 02:43:12 HST -10:00'
        expect(@happening1.updated_at)
          .to eq Time.parse('2013-08-29 02:43:12 -0400')

        @happening1.local_updated_at = '2013-11-11 12:34:56'
        expect(@happening1.updated_at)
          .to eq Time.parse('2013-11-11 12:34:56 -0500')
      end
    end

    describe 'local_created_at=(time_or_string)' do
      it 'sets created_at on the instance to a time_with_zone object only modifying the time zone' do
        expect(@happening1.created_at).to eq ' Tue, 01 Jan 2013 00:01:00 +0000'

        @happening1.local_created_at = Time.parse('Thu, 29 Aug 2013 02:40:12 HST -10:00')
        expect(@happening1.created_at)
          .to eq Time.parse('2013-08-29 02:40:12 -0400')

        @happening1.local_created_at = Time.parse('Thu, 29 Aug 2013 02:41:12')
        expect(@happening1.created_at)
          .to eq Time.parse('2013-08-29 02:41:12 -0400')

        @happening1.local_created_at = 'Thu, 29 Aug 2013 02:42:12'
        expect(@happening1.created_at)
          .to eq Time.parse('2013-08-29 02:42:12 -0400')

        @happening1.local_created_at = 'Thu, 29 Aug 2013 02:43:12 HST -10:00'
        expect(@happening1.created_at)
          .to eq Time.parse('2013-08-29 02:43:12 -0400')

        @happening1.local_created_at = '2013-11-11 12:34:56'
        expect(@happening1.created_at)
          .to eq Time.parse('2013-11-11 12:34:56 -0500')
      end
    end
  end
end

describe Event do
  before do
    @event1 = Event.find_by_name('Eastern Time (US & Canada)')
  end

  context 'Event should have time_jawn methods even though it has a non_conventional attribute' do
    subject { @event1 }

    it { should respond_to :local_start_time }
    it { should respond_to :local_created_at }
    it { should respond_to :local_updated_at }
    it { should respond_to :local_start_time= }
    it { should respond_to :local_created_at= }
    it { should respond_to :local_updated_at= }
    it { should respond_to :current_time }
  end
end

describe Occurrence do
  before do
    @occurrence1 = Occurrence.find_by_name('Eastern Time (US & Canada)')
  end

  context 'Ocurrence instance attribute accessor' do
    describe 'time_zone_attribute_name' do
      it 'should respond with the time_zone attribute name as defined in the class.' do
        expect(@occurrence1.class.time_zone_attribute_name).to eq :time_zone
      end
    end
  end

  context 'Occurrence should have time_jawn methods, except for local_updated_at, since it is not specified in the model' do
    subject { @occurrence1 }

    it { should respond_to :local_start_time }
    it { should respond_to :local_created_at }
    it { should_not respond_to :local_updated_at }
    it { should respond_to :local_start_time= }
    it { should respond_to :local_created_at= }
    it { should_not respond_to :local_updated_at= }
    it { should respond_to :current_time }
  end
end

describe Occasion do
  before do
    @occasion1 = Occasion.find_by_name('Eastern Time (US & Canada)')
  end

  context 'Occasion instance attribute accessor' do
    describe 'time_zone_attribute_name' do
      it 'should respond with the time_zone attribute name as defined in the class.' do
        expect(@occasion1.class.time_zone_attribute_name).to eq :t_z
      end
    end
  end

  context 'Occasion should have time_jawn methods, except for local_updated_at, since it is not specified in the model, even though it has a non_conventional attribute' do
    subject { @occasion1 }

    it { should respond_to :local_start_time }
    it { should_not respond_to :local_created_at }
    it { should_not respond_to :local_updated_at }
    it { should respond_to :local_start_time= }
    it { should_not respond_to :local_created_at= }
    it { should_not respond_to :local_updated_at= }
    it { should respond_to :current_time }
  end
end
