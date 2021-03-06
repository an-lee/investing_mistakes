module Tracable
  extend ActiveSupport::Concern

  included do
    validates :trace, presence: true, uniqueness: true

    before_validation :setup_trace, on: :create
  end

  def setup_trace
    if self.trace.nil?
      loop do
        candidate = SecureRandom.uuid
        unless self.class.exists?(trace: candidate)
          self.trace = candidate
          break
        end
      end
    end
  end

  def setup_transfer_trace
    if self.transfer_trace.nil?
      loop do
        candidate = SecureRandom.uuid
        unless self.class.exists?(transfer_trace: candidate)
          self.transfer_trace = candidate
          break
        end
      end
    end
  end
end
