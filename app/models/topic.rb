require 'xmlrpc/client'

class Topic
  FORUM_IDS = [6, 21, 45, 44] # Review, Archives, Denied, Waiting

  class << self
    def update_all
      self.fetch_topics(self::FORUM_IDS.join(',')) do |response|
        self.update_status(response)
      end
    end

    def fetch_topics(forum_ids, &block)
      server = XMLRPC::Client.new2('http://www.juggernautguild.com/interface/board/')

      topics = server.call('fetchTopics', {
        :api_module   => 'ipb',
        :api_key      => Juggernaut[:ipb_api_key],
        :forum_ids    => forum_ids,
        :order_field  => 'started',
        :order_by     => 'desc',
        :offset       => 0,
        :limit        => 30
      })

      if block_given?
        topics.each do |topic|
          yield topic
        end
      else
        topics
      end
    end

    def update_status(response)
      if applicant = Applicant.find(:first, :conditions => {:topic_id => response['topic_id']})
        applicant.update_status_from_board!(response)
      end
    end
  end
end
