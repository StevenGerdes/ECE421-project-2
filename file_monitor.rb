require 'deferFileNotify'
class FileMonitor
	
	@@IN_ACCESS = 0x00000001	# File was accessed.
	@@IN_MODIFY	= 0x00000002	#File was modified. 
	@@IN_ATTRIB = 0x00000004	# Metadata changed. 
	@@IN_CLOSE_WRITE = 0x00000008	# Writtable file was closed.
	@@IN_CLOSE_NOWRITE = 0x00000010	# Unwrittable file closed. 
	@@IN_CLOSE =  (@@IN_CLOSE_WRITE | @@IN_CLOSE_NOWRITE) # Close.
	@@IN_OPEN = 0x00000020	# File was opened. 
	@@IN_MOVED_FROM = 0x00000040	# File was moved from X.
	@@IN_MOVED_TO = 0x00000080	# File was moved to Y. 
	@@IN_MOVE = (@@IN_MOVED_FROM | @@IN_MOVED_TO) # Moves.
	@@IN_CREATE = 0x00000100	# Subfile was created. 
	@@IN_DELETE = 0x00000200	# Subfile was deleted. 
	@@IN_DELETE_SELF = 0x00000400	# Self was deleted.
	@@IN_MOVE_SELF = 0x00000800	# Self was moved.  
	
	def initialize
		@children = Hash.new
	end

	def FileWatch(alt_type, duration, file_list, &operation)
		
		case alt_type 
		when :creation
			mask = @@IN_CREATE;
		when :deletion
			mask = @@IN_DELETE | @@IN_DELETE_SELF
		when :alteration
			mask = @@IN_ATTRIB | @@IN_MODIFY
		else
			puts 'invalid alteration type'
			return
		end

		file_list.each do |path|
				
				pathFile = File.expand_path(path)		
				dir = File.dirname(pathFile)
				file = File.basename(pathFile);
				@children[path+alt_type.to_s] = fork{ 
					loop do
						DeferFileNotify.watch(dir, file, mask)#blocks so no running on thread
						sleep(duration)
						operation.call
					end
				}
		end
	end

	def StopWatch(path, alt_type)
		begin
			Process.kill(:SIGINT,@children[path + alt_type.to_s])
		rescue Exception #when killing a process it throws an exception, we don't care about that though
			@children.delete(path + alt_type.to_s)
		end
	end

end
