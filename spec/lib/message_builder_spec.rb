require 'spec_helper'

module HipChat
  module Publisher
    shared_context "jenkins build result" do
      let(:previous_result) { Result::SUCCESS }
      let(:previous_build) do
        double('prev_build').tap do |b|
          b.stub(:full_display_name => 'project #1')
          b.stub(:duration_string   => '1 ms')
          b.stub(:url               => 'job/project/1/')
          b.stub(:result            => previous_result)

          b.stub_chain(:change_set, :items => [])
        end
      end

      let(:build) do
        double('build').tap do |b|
          b.stub(:full_display_name => 'project #2')
          b.stub(:duration_string   => '1 ms')
          b.stub(:url               => 'job/project/2/')
          b.stub(:previous_build    => previous_build)

          b.stub_chain(:change_set, :items => [])
        end
      end
      before {
        Java::jenkins::model::Jenkins.stub_chain(:instance, :root_url => 'http://example.com/')
      }

      let(:exclude_successes) { false }
      let(:messages) { builder_class.new(build).build_messages(:exclude_successes => exclude_successes) }

      subject { messages[0] }
    end

    MESSAGE_TEMPLATE = 'project #2 - %s after 1 ms'\
                       ' (<a href="http://example.com/job/project/2/">Open</a>)'

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
          its(:body) { should eq 'project #2 - Success after 1 ms' }
          its(:options) { should eq :color => 'green', :notify => false }
        end

        context "when exclude_succeeds is false" do
          let(:exclude_successes) { false }
          subject { messages }

          it { should_not be_empty }
        end

        context "when exclude_succeeds is true" do
          let(:exclude_successes) { true }
          subject { messages }

          it { should be_empty }

          context "when previous build was failed" do
            let(:previous_result) { Result::FAILURE }

            it { should_not be_empty }
          end
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

          its(:body) { should eq MESSAGE_TEMPLATE % '<b>FAILURE</b>' }

          it "includes name on second message" do
            messages[1].body.should == "Changed by \"author\""
          end

          it "renders second message as plain text" do
            messages[1].options[:message_format] = 'text'
          end
        end

        context 'git changeset' do
          let(:item) { double('item').tap { |i| i.stub(:author_name => 'Author Name', :author_email => 'author@example.com') } }
          before { build.stub_chain(:change_set, :items => [item, item]) }

          its(:body) { should eq MESSAGE_TEMPLATE % '<b>FAILURE</b>' }

          it "includes author name on second message" do
            messages[1].body.should == "Changed by \"Author Name\""
          end

          it "renders second message as plain text" do
            messages[1].options[:message_format] = 'text'
          end
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
