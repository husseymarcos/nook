class BillingController < ApplicationController
  def show
    @user = Current.user
  end
end
