module XMLRPCHelper
  module Response
    def self.[](key)
      unless @responses
        @responses = {
          :fetchTopics_review => [
            {
              'start_date'  => '1268442340',
              'starter_id'  => '1',
              'last_post'   => '1270069593',
              'title'       => 'Name - Class - 2010-04-02',
              'tid'         => '12345',
              'forum_id'    => '6',
              'pinned'      => '1',
              'description' => 'stage 1 app as of 3/23/10',
              'topic_id'    => '12345'
            }
          ],
          :fetchTopics_archives => [
            {
              'start_date'  => '1268442340',
              'starter_id'  => '1',
              'last_post'   => '1270069593',
              'title'       => 'Name - Class - 2010-04-02',
              'tid'         => '12345',
              'forum_id'    => '21',
              'pinned'      => '0',
              'description' => 'stage 1 app as of 12/22; stage 2 app as of 1/14',
              'topic_id'    => '12345'
            }
          ],
          :fetchTopics_declined => [
            {
              'start_date'  => '1268442340',
              'starter_id'  => '1',
              'last_post'   => '1270069593',
              'title'       => 'Name - Class - 2010-04-02',
              'tid'         => '12345',
              'forum_id'    => '45',
              'pinned'      => '0',
              'description' => 'DECLINED',
              'topic_id'    => '12345'
            }
          ],
          :fetchTopics_waiting => [
            {
              'start_date'  => '1268442340',
              'starter_id'  => '1',
              'last_post'   => '1270069593',
              'title'       => 'Name - Class - 2010-04-02',
              'tid'         => '12345',
              'forum_id'    => '44',
              'pinned'      => '0',
              'description' => 'WAITING',
              'topic_id'    => '12345'
            }
          ]
        }
      end
      @responses[key]
    end
  end
end