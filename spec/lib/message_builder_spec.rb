require 'spec_helper'

module HipChat
  module Publisher
    shared_context "jenkins build result" do
      let(:build) do
        b = double('build')
        b.stub(:full_display_name => 'project #1')
        b.stub(:duration_string   => '1 ms')
        b.stub(:url               => 'job/project/1/')
        b
      end

      subject do
        builder = builder_class.new(build)
        builder.jenkins_url = 'http://example.com'
        builder.build_message
      end
    end

    MESSAGE_TEMPLATE = 'project #1 - %s after 1 ms'\
                       ' (<a href="http://example.com/job/project/1/">Open</a>)'

    describe SuccessMessageBuilder do
      include_context "jenkins build result"
      let(:builder_class) { SuccessMessageBuilder }

      describe '#build' do
        its(:body) { should eq MESSAGE_TEMPLATE % 'Success' }
        its(:options) { should eq :color => 'green', :notify => false }
      end
    end

    describe UnstableMessageBuilder do
      include_context "jenkins build result"
      let(:builder_class) { UnstableMessageBuilder }

      describe '#build' do
        its(:body) { should eq MESSAGE_TEMPLATE % 'Unstable' }
        its(:options) { should eq :color => 'yellow', :notify => true }
      end
    end

    describe FailureMessageBuilder do
      include_context "jenkins build result"
      let(:builder_class) { FailureMessageBuilder }

      describe '#build' do
        its(:body) { should eq MESSAGE_TEMPLATE % '<b>FAILURE</b>' }
        its(:options) { should eq :color => 'red', :notify => true }
      end
    end

    describe NotBuiltMessageBuilder do
      include_context "jenkins build result"
      let(:builder_class) { NotBuiltMessageBuilder }

      describe '#build' do
        its(:body) { should eq MESSAGE_TEMPLATE % 'Not Built' }
        its(:options) { should eq :color => 'yellow', :notify => true }
      end
    end

    describe AbortedMessageBuilder do
      include_context "jenkins build result"
      let(:builder_class) { AbortedMessageBuilder }

      describe '#build' do
        its(:body) { should eq MESSAGE_TEMPLATE % 'ABORTED' }
        its(:options) { should eq :color => 'yellow', :notify => false }
      end
    end

  end
end
