require 'hipchat/publisher/git_workaround'

module HipChat
  module Publisher
    module MessageBuilder
      attr_reader :build
      attr_reader :color
      attr_reader :notify
      attr_reader :status

      def build_messages
        [Message.new(message, :color => color, :notify => notify)]
      end

      private
      def message
        msg = "#{build.full_display_name} - #{status} after #{build.duration_string}"
        instance = Java::jenkins::model::Jenkins.instance
        if instance && instance.root_url
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

      def build_messages
        change_set_mes = change_set_message
        if change_set_mes
          super + [Message.new(change_set_mes, :color => color, :notify => notify, :message_format => 'text')]
        else
          super
        end
      end

      private

      def change_set_message
        items = build.change_set.items
        return nil if items.empty?
        names = items.map { |i|
          if i.respond_to? :author_name # GitChangeSet
            "\"#{i.author_name}\""
          else
            "\"#{i.author.full_name}\""
          end
        }.uniq
        "Changed by #{names.join(' ')}"
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
