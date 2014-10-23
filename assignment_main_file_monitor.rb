require 'file_monitor'

monitor = FileMonitor.new
monitor.FileWatch(:creation, 1000, ['test1','test2','test3']){puts 'created' }

