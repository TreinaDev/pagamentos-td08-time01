class PromotionsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @promotions = Promotion.all
  end
end