# frozen_string_literal: true

class PromotionsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @promotions = Promotion.all
  end

  def new
    @promotion = Promotion.new
    select_client_categories
  end

  def create
    @promotion = Promotion.new(promotion_params)
    if @promotion.save
      redirect_to promotions_path, notice: 'Promoção cadastrada com sucesso'
    else
      select_client_categories
      flash.now[:alert] = 'Erro ao cadastrar promoção'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def select_client_categories
    @client_categories = ClientCategory.all
  end

  def promotion_params
    params.require(:promotion).permit(:name, :start_date, :end_date, :discount_percent, :limit_day, :client_category_id)
  end
end
