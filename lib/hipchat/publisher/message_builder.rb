module HipChat
  module Publisher

    module MessageBuilder
      attr_reader :color
      attr_reader :notify

      def build_message
        Message.new(message, :color => color, :notify => notify)
      end
    end

    class SuccessMessageBuilder
      include MessageBuilder

      def initialize(build)
        @color  = 'green'
        @notify = false
      end

      def message
        'SUCCESS'
      end
    end

    class UnstableMessageBuilder
      include MessageBuilder

      def initialize(build)
        @color  = 'yellow'
        @notify = true
      end

      def message
        'UNSTABLE'
      end
    end

    class FailureMessageBuilder
      include MessageBuilder

      def initialize(build)
        @color  = 'red'
        @notify = true
      end

      def message
        'FAILURE'
      end
    end

    class NotBuiltMessageBuilder
      include MessageBuilder

      def initialize(build)
        @color  = 'red'
        @notify = true
      end

      def message
        'NOT BUILT'
      end
    end

    class AbortedMessageBuilder
      include MessageBuilder

      def initialize(build)
        @color  = 'yellow'
        @notify = false
      end

      def message
        'ABORTED'
      end
    end

  end
end
