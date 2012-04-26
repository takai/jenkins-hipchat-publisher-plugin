module HipChat
  module Publisher

    module MessageBuilder
      attr_reader :build
      attr_reader :color
      attr_reader :notify
      attr_reader :status

      def build_message
        Message.new(message, :color => color, :notify => notify)
      end

      private
      def message
        msg = "#{build.full_display_name} - #{status} after #{build.duration_string}"
        if instance = Java::jenkins::model::Jenkins.instance
          msg << " (<a href=\"#{instance.root_url.chomp('/')}/#{build.url}\">Open</a>)"
        end
        msg
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
