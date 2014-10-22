require 'shell'
class RShell
#  attr_reader working_directory

	def initialize
		@working_directory = Dir.pwd
		@shell_name = 'RShell'
		run
	end

	def run
#		trap('INT', 'IGNORE')
		input = nil
		shell = Shell.new
		
		#until input.to_s == 'exit'
		loop do begin	
			input = gets.strip
			if(  input.to_s == 'exit' )
				return
			end
			
			f = IO.popen(input)
			puts f.readlines
			f.close
			
		rescue Interrupt
			puts ""
		end end
	end

end
RShell.new
#I was under the impression that we cannot use backtics as the linux shell "doesn't exist"
