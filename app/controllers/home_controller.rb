# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_admin!

  def index
    @client_transactions_count = ClientTransaction.pending.count
    @admin_count = Admin.pending.count
  end
end
