require 'test/unit'

class ShellContract < Test::Unit::TestCase

  def test_execute
    shell = Shell.new

    test_string = 'the quick brown fox jumps over the lazy brown dog'
    execution_text = "echo #{test_string}"

    std_out_message = StringIO.new
    $stdout = std_out_message

    #invariant
    old_shell = shell.clone

    #precondition
    assert_equal(shell.working_directory, ENV['path'])
    assert_respond_to( execution_text, :to_s)

    shell.execute(execution_text)

    #postcondition
    assert_equal(std_out_message.string, test_string)

    #invarients
    assert_equal(shell, old_shell)
  end

  def test_change_directory
    shell = Shell.new

    directory_to_go_to = '/bin'

    #invariant
    shell_credentials = shell.credentials

    #precondition
    assert_equal(shell.working_directory, ENV['path'])
    assert_true(File.directory? directory_to_go_to )#make sure the directory exists
    assert_true(File.readable? directory_to_go_to )#make sure it has permissions for the cd

    shell.execute("cd #{directory_to_go_to}")

    #postcondition
    assert_equal(shell.working_directory, directory_to_go_to)

    #invarients
    assert_equal(shell.credentials, shell_credentials)
  end

  def test_pipe
    shell = Shell.new

    execution_text = 'cat test.txt | echo'
    file_text = 'yay I created a file'

    out_file = File.new('out.txt', 'w')
    out_file.puts(file_text)
    out_file.close

    std_out_message = StringIO.new
    $stdout = std_out_message

    #invariant
    old_shell = shell.clone

    #precondition
    assert_equal(shell.working_directory, ENV['path'])
    assert_respond_to( execution_text, :to_s)

    shell.execute(execution_text)

    #postcondition this post condition is showing that the output of one operation was piped to the other
    assert_equal(std_out_message.string, file_text)

    #invarients
    assert_equal(shell, old_shell)
  end

end
