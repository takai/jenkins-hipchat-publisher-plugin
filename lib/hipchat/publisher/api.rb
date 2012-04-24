require 'java'

import 'org.apache.commons.httpclient.HttpClient'
import 'org.apache.commons.httpclient.methods.PostMethod'

module HipChat
  module Publisher
    class API
      attr_reader :token, :room_id, :from

      URL_MESSAGE = 'https://api.hipchat.com/v1/rooms/message?auth_token=%s'

      def initialize(token, room_id, from)
        @token   = token
        @room_id = room_id
        @from    = from
      end

      def rooms_message(message, params = {})
        post = PostMethod.new(request_url)
        post.add_parameter 'room_id', room_id
        post.add_parameter 'from',    from
        post.add_parameter 'message', message

        post.add_parameter 'color',   params[:color]       if params[:color]
        post.add_parameter 'notify',  params[:notify].to_s if params[:notify]

        post.params.content_charset = 'UTF-8'

        client = HttpClient.new
        client.execute_method post

        post.release_connection

        case post.status_code
        when 200
          return

        when 401
          raise "Access denied to room `#{room_id}'"

        when 404
          raise "Unknown room: #{room_id}"

        else
          raise "Unexpected #{post.status_code} for room `#{room_id}'"
        end
      end

      private
      def request_url
        URL_MESSAGE % token
      end

    end
  end
end
