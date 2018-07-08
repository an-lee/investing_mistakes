module Tracable
  extend ActiveSupport::Concern

  included do
    validates :trace, presence: true, uniqueness: true

    before_validation :setup_trace, on: :create
  end

  private

  def setup_trace
    loop do
      now = Time.current
      candidate = now.strftime('%Y%m%d%H%M%S') + now.nsec.to_s
      candidate.ljust(24, rand(10).to_s)
      unless self.class.exists?(trace: candidate)
        self.trace = candidate
        break
      end
    end
  end
end
