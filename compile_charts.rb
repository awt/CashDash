#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'

require 'optparse'
require 'json'
require 'yaml'
require 'mixpanel_client'
require File.join(File.dirname(__FILE__), 'lib', 'config')
require File.join(File.dirname(__FILE__), 'database')
require File.join(File.dirname(__FILE__), 'lib', 'mixpanel_client')


def camelize(str)
  str.split('_').map {|w| w.capitalize}.join
end

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: compile_charts.rb [options]"

  opts.on("-n", "--no-data", "Skip data gathering") do |n|
    options[:no_data] = true 
  end

  opts.on("-c", "--chart CHART") do |c|
    options[:chart] = c
  end

end.parse!

formatters_path = File.join(File.dirname(__FILE__), 'formatters')
chart_config = CashDash::Config.instance.get_config['charts']
charts = options[:chart].nil? ? chart_config : {options[:chart] => chart_config[options[:chart]]}
if(!chart_config[options[:chart]].nil?)
  charts.each_pair do |name, config|
    require File.join(formatters_path, name)
    chart = Chart.get(name) 
    if(!options[:no_data])
      config['series'] = Kernel.const_get(camelize(name)).generate_series
    end
    if chart.nil?
      Chart.create(:name => name, :config => config.to_json)
    else
      if config['series']
        chart.config = config.to_json
        chart.save
      else
        config['series'] = JSON.parse(chart.config)['series']
        chart.config = config.to_json
        chart.save
      end
    end
  end
else
  puts "Unkown chart: #{options[:chart]}"
end


