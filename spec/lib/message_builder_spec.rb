require 'spec_helper'

module HipChat
  module Publisher
    describe SuccessMessageBuilder do
      describe '#build' do
        let(:build) { double('build') }
        subject { SuccessMessageBuilder.new(build).build }

        its(:body) { should eq 'SUCCESS' }
        its(:options) { should eq :color => 'green', :notify => false }
      end
    end

    describe UnstableMessageBuilder do
      describe '#build' do
        let(:build) { double('build') }
        subject { UnstableMessageBuilder.new(build).build }

        its(:body) { should eq 'UNSTABLE' }
        its(:options) { should eq :color => 'yellow', :notify => true }
      end
    end

    describe FailureMessageBuilder do
      describe '#build' do
        let(:build) { double('build') }
        subject { FailureMessageBuilder.new(build).build }

        its(:body) { should eq 'FAILURE' }
        its(:options) { should eq :color => 'red', :notify => true }
      end
    end

    describe NotBuiltMessageBuilder do
      describe '#build' do
        let(:build) { double('build') }
        subject { NotBuiltMessageBuilder.new(build).build }

        its(:body) { should eq 'NOT BUILT' }
        its(:options) { should eq :color => 'red', :notify => true }
      end
    end

    describe AbortedMessageBuilder do
      describe '#build' do
        let(:build) { double('build') }
        subject { AbortedMessageBuilder.new(build).build }

        its(:body) { should eq 'ABORTED' }
        its(:options) { should eq :color => 'yellow', :notify => false }
      end
    end

  end
end
