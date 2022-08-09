class Api::V1::PropertiesController < ApplicationController
  before_action :set_property, only: [:show, :update]
  # after_action :set_csrf_token_header, only: [:show]

  def index
    @properties = Property.includes(:label)
  end

  def show
  end

  def update
    if @property.update(content: property_params[:content])
      render file: "select-update-api/front/pages/index", json: 'succes!', status: 200
    else
      render file: "select-update-api/front/pages/index", json: @property, status: 500
    end
  end

  private
  def set_property
    @property = Property.find_by(id: params[:id])
  end

  def property_params
    params.require(:property).permit(:content,
                                      label: [
                                        # :id,
                                        :status,
                                      ])
  end
end
