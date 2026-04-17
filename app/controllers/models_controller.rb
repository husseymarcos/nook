class ModelsController < ApplicationController
  def index
    @models = ModelCatalog.available_chat_models
  end

  def show
    @model = Model.find(params[:id])
  end
end
