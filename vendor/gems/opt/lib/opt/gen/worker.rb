require 'colored'

class Opt::Gen::Worker
  
  def self.initiate(message)
    @start = Time.now
    #logger.debug "-- " << message
  end
  
  def self.complete
    say_time(Time.now - @start)
  end
  
  def self.say_time(time)
    output_string = "   -> " << (time).round(3).to_s << "secs"
    # logger.debug output_string.green  if time.between?(0,2)
    # logger.debug output_string.yellow if time.between?(2,10)
    # logger.debug output_string.red    if time > 10
  end
  
end