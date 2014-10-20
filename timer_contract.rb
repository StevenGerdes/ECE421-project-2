require 'test/unit'

class TimerContract < Test::Unit::TestCase

  def test_start
    wait_time = 1000 # 1 second
    message = 'message'
    timer = Timer.new(wait_time, message )

    std_out_message = StringIO.new
    $stdout = std_out_message

    #invariant
    internal_message = timer.message

    #precondition
    #none

    start_time = timer.start

    #we must wait because the timer runs in parallel
    sleep(1.5)

    #postcondition
    assert_equal(start_time + wait_time, timer.last_run)
    assert_equal(message, std_out_message.string.strip)

    #invarients
    assert_equal(timer.message, internal_message)
  end

  def test_end
    timer = Timer.new(1000 * 60, 'message' )

    std_out_message = StringIO.new
    $stdout = std_out_message

    #invariant
    old_timer = timer.clone

    timer.start

    #precondition
    assert_true( timer.is_running, true )

    timer.end

    #postcondition
    assert_empty(std_out_message.string)

    #invarients
    assert_equal(timer, old_timer)
  end

end