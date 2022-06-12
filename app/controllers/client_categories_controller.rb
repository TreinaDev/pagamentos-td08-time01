# frozen_string_literal: true

class ClientCategoriesController < ApplicationController
  def index
    @client_categories = ClientCategory.all
  end

  def new
    @client_category = ClientCategory.new
  end

  def create
    @client_category = ClientCategory.new(client_category_params)

    if @client_category.save
      redirect_to client_categories_path, notice: 'Categoria criada com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível cadastrar a categoria.'
      render :new
    end
  end

  private

  def client_category_params
    params.require(:client_category).permit(:name, :discount_percent)
  end
end
