
#!/usr/bin/env ruby
require 'optparse'
require 'active_support/all'
require 'yaml'
require 'rest-client'




BASE_REQUEST = 'https://www.timecamp.com/third_party/api'

options = {}

def api_token
  token = ''
  File.open("#{ ENV["HOME"] }/.timecamp", 'r') do |file|
    hash = YAML.load(file.read)
    token = hash[:api_token]
  end
  return token
end

OptionParser.new do |parser|
  parser.on("-s", "--set_token TOKEN", "Set the API token.") do |token|
    options[:token] = token
  end
  parser.on("-t", "--begin TASK", "Begin timing task.") do |task|
    options[:task] = task
  end
  parser.on('-g', '--get_today', "Get today's entries") do |task|
    from = Date.today.beginning_of_day.strftime('%Y-%m-%d')
    to = Date.today.end_of_day.strftime('%Y-%m-%d')
    uri = BASE_REQUEST + "/entries/format/json/api_token/#{ api_token }/from/#{ from }/to/#{ to }"

    response = RestClient.get uri
    JSON.parse(response.body).each{ |entry| puts entry }
  end
end.parse!


# if given a token
if options[:token].present?
  # open file
  File.open("#{ ENV["HOME"] }/.timecamp", 'w') do |file|
    hash = {}
    hash[:api_token] = options[:token]
    file << hash.to_yaml
  end
end

# if given a task
if options[:task].present?
  uri = URI.parse("#{BASE_REQUEST}/")
  response = RestClient.post(uri)
end




