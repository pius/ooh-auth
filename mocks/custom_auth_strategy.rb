class CustomStrategyDetector; end
class MyDistinctiveStrategyError < StandardError; end
class MyAwesomeCustomAuthStrategy < Merb::Authentication::Strategy
  def run!
    CustomStrategyDetector.has_run = true
    return false
  end
end