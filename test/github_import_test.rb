require File.join(File.dirname(__FILE__), '../', 'mixdash')
require 'test/unit'
require 'rack/test'

class GitHubImportTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_post_from_github
    post '/api/receive_commits'
  end
end

