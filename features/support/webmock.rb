require 'webmock/cucumber'

WebMock.allow_net_connect!(:net_http_connect_on_start => true)

Before do
  stub_request(:post, "http://watchout4snakes.com/wo4snakes/Random/RandomWord").to_return(:status => 200, :headers => {}, :body => "testword")
end
