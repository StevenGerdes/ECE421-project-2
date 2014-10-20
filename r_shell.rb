
class RShell
#  attr_reader working_directory

  def initialize
    @working_directory = Dir.pwd
    @shell_name = 'RShell'
    run
  end

  def run
  input = nil
    until input.to_s == 'exit'

      input = gets.strip.split ' '
      cmd = input[0]
      args = input[1..input.length]
      puts "#{@shell_name}: #{cmd}: command not found"

    end
  end


end
RShell.new
#I was under the impression that we cannot use backtics as the linux shell "doesn't exist"