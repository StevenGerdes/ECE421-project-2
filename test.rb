require 'file_monitor'

t = FileMonitor.new
t.FileWatch(:deletion, 0, ["./test"]) {puts 'test'})

