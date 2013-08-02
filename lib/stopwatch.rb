# Simple method to time blocks
#
# Usage:
#   elapsed = Stopwatch.time do
#     ...
#   end
#
#   puts "Took #{elapsed.to_s} seconds."
class Stopwatch
  def self.time
    start = Time.now
    yield
    finish = Time.now
    return finish-start
  end
end
