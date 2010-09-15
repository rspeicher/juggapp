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
      server = XMLRPC::Client.new2(Juggernaut[:ipb_api_url])

      topics = server.call('fetchTopics', {
        :api_module   => 'ipb',
        :api_key      => Juggernaut[:ipb_api_key],
        :forum_ids    => forum_ids,
        :order_field  => 'started',
        :order_by     => 'desc',
        :offset       => 0,
        :limit        => 50
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
      response.symbolize_keys!
      if applicant = Applicant.where(:topic_id => response[:topic_id]).first
        applicant.update_status_from_board!(response)
      end
    end
  end
end
