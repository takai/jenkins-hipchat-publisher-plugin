module HipChat
  module Publisher

    module MessageBuilder
      attr_reader :build
      attr_reader :color
      attr_reader :notify
      attr_reader :status

      attr_accessor :jenkins_url

      def build_message
        Message.new(message, :color => color, :notify => notify)
      end

      private
      def jenkins
        Java.jenkins.model.Jenkins.getInstance()
      end

      def message
        "#{build.full_display_name} - #{status}" \
        " after #{build.duration_string}" \
        " (<a href=\"#{jenkins_url}/#{build.url}\">Open</a>)"
      end
    end

    class SuccessMessageBuilder
      include MessageBuilder

      def initialize(build)
        @build  = build
        @status = 'Success'
        @color  = 'green'
        @notify = false
      end
    end

    class UnstableMessageBuilder
      include MessageBuilder

      def initialize(build)
        @build  = build
        @status = 'Unstable'
        @color  = 'yellow'
        @notify = true
      end
    end

    class FailureMessageBuilder
      include MessageBuilder

      def initialize(build)
        @build  = build
        @status = '<b>FAILURE</b>'
        @color  = 'red'
        @notify = true
      end
    end

    class NotBuiltMessageBuilder
      include MessageBuilder

      def initialize(build)
        @build  = build
        @status = 'Not Built'
        @color  = 'yellow'
        @notify = true
      end
    end

    class AbortedMessageBuilder
      include MessageBuilder

      def initialize(build)
        @build  = build
        @status = 'ABORTED'
        @color  = 'yellow'
        @notify = false
      end
    end

  end
end
