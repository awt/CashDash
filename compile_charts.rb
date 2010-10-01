#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'

require 'json'
require 'yaml'
require 'mixpanel_client'
require File.join(File.dirname(__FILE__), 'lib', 'config')
require File.join(File.dirname(__FILE__), 'database')
require File.join(File.dirname(__FILE__), 'lib', 'mixpanel_client')


def camelize(str)
  str.split('_').map {|w| w.capitalize}.join
end

formatters_path = File.join(File.dirname(__FILE__), 'formatters')
CashDash::Config.instance.get_config['charts'].each_pair do |name, config|
  require File.join(formatters_path, name)
  config['series'] = Kernel.const_get(camelize(name)).generate_series
  chart = Chart.get(name) 
  if chart.nil?
    Chart.create(:name => name, :config => config.to_json)
  else
    chart.config = config.to_json
    chart.save
  end
end


