require 'bundler/setup'
require 'hipchat/api'

require 'java'

import 'hudson.model.Result'

class HipchatPublisher < Jenkins::Tasks::Publisher

  SENDER = 'Jenkins'

  display_name "HipChat publisher"

  attr_reader :token
  attr_reader :room

  def initialize(opts)
    @token = opts['token']
    @room  = opts['room']
  end

  def prebuild(build, listener)
  end

  def perform(build, launcher, listener)

    api = HipChat::API.new(token, room, SENDER)

    case build.native.result
    when Result::SUCCESS
      api.rooms_message('SUCCESS',   :color => 'green',  :notify => false)

    when Result::UNSTABLE
      api.rooms_message('UNSTABLE',  :color => 'yellow', :notify => true)

    when Result::FAILURE
      api.rooms_message('FAILURE',   :color => 'red',    :notify => true)

    when Result::NOT_BUILD
      api.rooms_message('NOT BUILD', :color => 'purple', :notify => true)

    when Result::ABORTED
      api.rooms_message('ABORTED',   :color => 'purple', :notify => true)
    end
  rescue
    listener.error "[HipChat Publisher] " + $!.message
  end

end
