require 'spec_helper'

module HipChat
  module Publisher
    describe MessageBuilderFactory do
      describe '#create' do
        let(:build) { double('build', :result => result) }
        subject { MessageBuilderFactory.create(build) }

        context 'build is success' do
          let(:result) { Result::SUCCESS }
          it { should be_instance_of SuccessMessageBuilder }
        end

        context 'build is unstable' do
          let(:result) { Result::UNSTABLE }
          it { should be_instance_of UnstableMessageBuilder }
        end

        context 'build is failure' do
          let(:result) { Result::FAILURE }
          it { should be_instance_of FailureMessageBuilder }
        end

        context 'build is not built' do
          let(:result) { Result::NOT_BUILT }
          it { should be_instance_of NotBuiltMessageBuilder }
        end

        context 'build is aborted' do
          let(:result) { Result::ABORTED }
          it { should be_instance_of AbortedMessageBuilder }
        end
      end
    end
  end
end
