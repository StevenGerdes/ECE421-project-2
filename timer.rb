require 'deferFileNotify'

class Timer
	@@nsec_per_msec = 1000000
	def initialize(message, wait_time_ms)
		@message = message
		if !wait_time_ms.respond_to? :to_i
			puts 'invalid wait time: setting it to one second'
			wait_time_ms = 1000
		end
		@wait_time = wait_time_ms.to_i * @@nsec_per_msec
	end

  #Start the timer, if it is already running do nothing
	def start
		if(@running)
			return @start_time
		end

		@running = true
		@job_id = DeferFileNotify.deferNanoSec(Proc.new{
			puts @message
			@last_run = Time.now
			set_end
		}, @wait_time )
		@start_time = Time.now
		return @start_time
	end

  #Stop the timer
	def stop
		if(@running)
			DeferFileNotify.stop(@job_id)
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
		@start_time = nil
		@running = false
	end
end
