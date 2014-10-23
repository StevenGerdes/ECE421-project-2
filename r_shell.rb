require 'timer'

class RShell
#  attr_reader working_directory

	def initialize
		run
	end

  #Run command starts R_Shell, looping infinitely for input until the eit command is given.
	def run
		input = nil
		
		loop do 
		begin	
			print '>'
			input = gets.strip.split('|')
			if(  input.to_s == 'exit' )
				return
			end
			
			lastOutPut = nil
			input.each{|cmd|
				if cmd.start_with? 'cd ' 
					Dir.chdir(cmd[3..-1])
					lastOutPut = nil
				elsif cmd.start_with? 'timer '
					Timer.new(*(cmd[6..-1].split(' '))).start
				else		
					IO.popen(cmd, "r+") do |pipe|
						pipe.puts lastOutPut unless lastOutPut.nil?
						pipe.close_write  
						lastOutPut = pipe.read.to_s
					end
				end
			}
			puts lastOutPut unless lastOutPut.nil?
		rescue Exception	
			puts ""
		end
		
		end
	end

end
