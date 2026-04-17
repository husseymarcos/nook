class Billing::CancellationsController < ApplicationController
  def show
    redirect_to billing_path, alert: "Checkout cancelled. You can upgrade anytime."
  end
end
