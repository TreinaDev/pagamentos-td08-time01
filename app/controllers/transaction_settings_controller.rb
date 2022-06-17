# frozen_string_literal: true

class TransactionSettingsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_transaction_setting, only: %i[edit update]

  def new
    redirect_to edit_transaction_setting_path(TransactionSetting.last.id) if TransactionSetting.all.present?

    @transaction_setting = TransactionSetting.new
  end

  def create
    @transaction_setting = TransactionSetting.new(transaction_settings_params)

    if @transaction_setting.save
      redirect_to edit_transaction_setting_path(@transaction_setting.id),
                  notice: 'A configuração foi cadastrada com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível cadastrar a configuração.'

      render :new
    end
  end

  def edit; end

  def update
    if @transaction_setting.update(transaction_settings_params)
      redirect_to edit_transaction_setting_path(@transaction_setting.id),
                  notice: 'A configuração foi atualizada com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível atualizar a configuração.'

      render :edit
    end
  end

  private

  def transaction_settings_params
    params.require(:transaction_setting).permit(:max_credit)
  end

  def set_transaction_setting
    @transaction_setting = TransactionSetting.find(params[:id])
  end
end
