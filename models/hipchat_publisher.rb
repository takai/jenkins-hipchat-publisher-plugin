require 'bundler/setup'
require 'hipchat/publisher'
require 'ruby-debug'

class HipchatPublisher < Jenkins::Tasks::Publisher

  display_name "HipChat Publisher"

  attr_accessor :token
  attr_accessor :room

  def initialize(opts)
    @token = opts['token']
    @room  = opts['room']
  end

  def prebuild(build, listener)
  end

  def perform(build, launcher, listener)
    builder  = HipChat::Publisher::MessageBuilderFactory.create(build.native)
    messages = builder.build_messages

    api = HipChat::Publisher::API.new(token, room, 'Jenkins')
    messages.each do |message|
      api.rooms_message(message.body, message.options)
    end
  rescue
    listener.error "[HipChat Publisher] " + $!.message
  end

end
