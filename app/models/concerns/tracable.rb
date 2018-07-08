module Tracable
  extend ActiveSupport::Concern

  included do
    validates :trace, presence: true, uniqueness: true

    before_validation :setup_trace, on: :create
  end

  private

  def setup_trace
    loop do
      candidate = SecureRandom.uuid
      unless self.class.exists?(trace: candidate)
        self.trace = candidate
        break
      end
    end
  end
end
