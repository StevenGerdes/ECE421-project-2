
require 'defer'

var = false;
Defer.deferNanoSec(Proc.new{ 
	puts 'one'
}, 5000000000 )

Defer.deferNanoSec(Proc.new{
	puts 'two'
	Defer.deferNanoSec(Proc.new{
	puts 'callback inception'
	}, 10 );
}, 5000000000 )

Defer.deferNanoSec(Proc.new{ 
	puts 'one'
}, 8000000000 )

Defer.deferNanoSec(Proc.new{ 
	puts 'three'

}, 5 )

until var
	puts 'okay';
	sleep(1);
end
