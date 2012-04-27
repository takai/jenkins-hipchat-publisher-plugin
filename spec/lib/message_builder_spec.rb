require 'spec_helper'

module HipChat
  module Publisher
    shared_context "jenkins build result" do
      let(:build) do
        double('build').tap do |b|
          b.stub(:full_display_name => 'project #1')
          b.stub(:duration_string   => '1 ms')
          b.stub(:url               => 'job/project/1/')

          b.stub_chain(:change_set, :items => [])
        end
      end
      before {
        Java::jenkins::model::Jenkins.stub_chain(:instance, :root_url => 'http://example.com/')
      }

      subject { builder_class.new(build).build_message }
    end

    MESSAGE_TEMPLATE = 'project #1 - %s after 1 ms'\
                       ' (<a href="http://example.com/job/project/1/">Open</a>)'

    describe SuccessMessageBuilder do
      include_context "jenkins build result"
      let(:builder_class) { SuccessMessageBuilder }

      describe '#build' do
        context 'Jenkins URL is set' do
          its(:body) { should eq MESSAGE_TEMPLATE % 'Success' }
          its(:options) { should eq :color => 'green', :notify => false }
        end
        context 'Jenkins URL is not set' do
          before { Java::jenkins::model::Jenkins.stub_chain(:instance, :root_url => nil) }
          its(:body) { should eq 'project #1 - Success after 1 ms' }
          its(:options) { should eq :color => 'green', :notify => false }
        end
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
        context 'default changeset' do
          let(:item) { double('item').tap { |i| i.stub_chain(:author, :full_name => 'author') } }
          before { build.stub_chain(:change_set, :items => [item, item]) }

          its(:body) { should eq MESSAGE_TEMPLATE % '<b>FAILURE</b>' + '<br>&emsp;changed by @author' }
        end

        context 'git changeset' do
          let(:item) { double('item').tap { |i| i.stub(:author_name => 'Author Name') } }
          before { build.stub_chain(:change_set, :items => [item, item]) }

          its(:body) { should eq MESSAGE_TEMPLATE % '<b>FAILURE</b>' + '<br>&emsp;changed by @"Author Name"' }
        end

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
