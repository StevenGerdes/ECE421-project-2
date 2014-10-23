require 'test/unit'

class FileMonitorContract < Test::Unit::TestCase

  def test_watch

    alteration_type = :creation
    duration = 10000
    list_of_files = ["#{ENV['path']}/out.txt", 'file2', 'file3']
    file_text = 'yay I created a file'
    monitor = FileMonitor.new

    std_out_message = StringIO.new
    $stdout = std_out_message

    #preconditions
    assert_true(alteration_type == :creation || alteration_type == :deletion || alteration_type == :alteration )
    assert_respond_to( duration, :to_i )
    assert_respond_to( list_of_files, :each )

    monitor.FileWatch( alteration_type, duration, list_of_files ){|file| puts File.read(file) }

    out_file = File.new('out.txt', 'w')
    out_file.puts(file_text)
    out_file.close

    #postconditions, this post condition is just showing that the block was executed what actually happens is dependent on the
    #code in the block
    assert_equal(file_text, std_out_message.string)

    #invariants


  end

end
