class PaymentsCallbacksController < ApplicationController
  def index
    Rails.logger(params)
  end
end
