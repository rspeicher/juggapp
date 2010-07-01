require 'xmlrpc/server'
require 'pp'

server = XMLRPC::Server.new(8080)

server.add_handler('postTopic') do |options|
  puts '-' * 50
  puts 'postTopic received with the following options:'
  pp options

  { 'result' => 'success', 'topic_id' => '12345' }
end

server.serve
