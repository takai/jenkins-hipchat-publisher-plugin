module HipChat
  module Publisher
    class MessageBuilderFactory
      def self.create(build)
        case build.result
        when Result::SUCCESS
          SuccessMessageBuilder.new(build)

        when Result::UNSTABLE
          UnstableMessageBuilder.new(build)

        when Result::FAILURE
          FailureMessageBuilder.new(build)

        when Result::NOT_BUILT
          NotBuiltMessageBuilder.new(build)

        when Result::ABORTED
          AbortedMessageBuilder.new(build)
        end
      end
    end
  end
end
