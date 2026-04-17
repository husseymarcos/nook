class Billing::CheckoutsController < ApplicationController
  def create
    session = Current.user.start_checkout(redirect_url: billing_success_url)
    redirect_to session.url, allow_other_host: true
  end
end
