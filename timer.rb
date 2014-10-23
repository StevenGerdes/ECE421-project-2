require 'defer'

class Timer
	@@nsec_per_msec = 1000000
	def initialize(message, wait_time_ms)
		@message = message
		@wait_time = wait_time_ms.to_i * @@nsec_per_msec
	end

  #Start the timer, if it is already running do nothing
	def start
		if(@running)
			return
		end

		@running = true
		@job_id = Defer.deferNanoSec(Proc.new{
			puts @message
			@last_run = Time.now
			set_end
		}, @wait_time )
	end

  #Stop the timer
	def stop
		if(@running)
			Defer.stop(@job_id)
		end
		set_end
	end

  #restart the timer by stopping and starting
	def restart
		stop
		start
	end

  #check if the timer is running
	def running?
		@running
	end

  #returns the time that the timer last finished
	def last_run
		@last_run
	end

private
	def set_end
		@running = false
	end
end