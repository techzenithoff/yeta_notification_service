#require 'google/apis/youtube_v3'
#require './lib/shared_utils/utils'

#include SharedUtils::AppLogger
require 'rake'

class Logs::ClearLogsJob < ApplicationJob
 
  queue_as :default

  def perform
    
    max_log_size = 50.megabytes
  
    logs = File.join(Rails.root, 'log', '*.log')
    if Dir[logs].any? {|log| File.size?(log).to_i > max_log_size }
      $stdout.puts "Runing rake log:clear"
      `rake log:clear`
    end 
  rescue StandardError => e
    
  end

  
end