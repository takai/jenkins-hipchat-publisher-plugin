require 'bundler/setup'
require 'hipchat/publisher'

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
    builder = HipChat::Publisher::MessageBuilderFactory.create(build.native)
    builder.jenkins_url = Java::jenkins::model::Jenkins.instance.root_url

    message = builder.build_message

    api = HipChat::Publisher::API.new(token, room, 'Jenkins')
    api.rooms_message(message.body, message.options)
  rescue
    listener.error "[HipChat Publisher] " + $!.message
  end

end
