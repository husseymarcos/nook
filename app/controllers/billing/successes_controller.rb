class Billing::SuccessesController < ApplicationController
  def show
    redirect_to root_path, notice: "Welcome to Nook Premium!"
  end
end
