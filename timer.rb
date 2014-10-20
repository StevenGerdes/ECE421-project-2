class Timer
  attr_reader is_running, last_run

  def start
    @running = true;
  end

  def end
    @last_run = Time.now
    @is_running = false
  end


end