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

	def test_start_twice
		wait_time = 3000 
		message = 'message'
		timer = Timer.new(wait_time, message )


		#invariant
		internal_message = timer.message

		#precondition
		#none

		start_time = timer.start
		sleep(1)
		second_start_time = timer.start

		#postcondition
		assert_equal(start_time, second_start_time)

		#invarients
		assert_equal(timer.message, internal_message)
	end

  def test_stop
    timer = Timer.new(1000 * 60, 'message' )

    std_out_message = StringIO.new
    $stdout = std_out_message

    #invariant
    old_timer = timer.clone

    timer.start

    #precondition
    assert_true( timer.running?, true )

    timer.stop

    #postcondition
    assert_empty(std_out_message.string)

    #invarients
    assert_equal(timer, old_timer)
  end

end