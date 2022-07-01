# frozen_string_literal: true

class ClientsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_params, only: %i[edit update]

  def index
    @clients = Client.all
  end

  def edit
    select_client_categories
  end

  def update
    return redirect_to clients_path, notice: 'Cliente atualizado com sucesso!' if @client.update(client_params)
  end

  private

  def set_params
    @client = Client.find(params[:id])
  end

  def select_client_categories
    @client_categories = ClientCategory.all
  end

  def client_params
    params.require(:client).permit(:client_category_id)
  end
end
