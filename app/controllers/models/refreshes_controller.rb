class Models::RefreshesController < ApplicationController
  def create
    Model.refresh!
    redirect_to models_path, notice: "Models refreshed successfully"
  end
end
