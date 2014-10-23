require 'timer'
require 'deferFileNotify'
require 'r_shell'
require 'file_monitor'

t1 = Timer.new('one', 2000);
t2 = Timer.new('two', 2000);
t3 = Timer.new('three', 3000);
t4 = Timer.new('four', 5);

t1.start
t2.start
t3.start
t4.start

var = false;

DeferFileNotify.deferNanoSec(Proc.new{
	DeferFileNotify.deferNanoSec(Proc.new{
	puts 'callback inception'
	var = true;
	}, 1000000000 );
}, 4000000000 )


until var
	puts '.';
	sleep(1);
end

monitor = FileMonitor.new
monitor.FileWatch(:creation, 1, ['test1']){puts 'created' }

#for some unknown reason I cannot require two .so files in the same file 
#So please run assignment_main_fileWatch.rb for examples of that code

#This will start the shell. I cannot show how to use this in a ruby file becuase it isn't concurrent 
#Simply type commands as if it was a normal shell. There is no tab completion
RShell.new


