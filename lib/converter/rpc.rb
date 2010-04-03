require File.expand_path(File.join(File.dirname(__FILE__),'..','..','config','environment'))

Topic.fetch_topics('21') do |response|
  puts "Response: #{response['topic_id']} - #{response['title']}"
  Topic.update_status(response)
end