# frozen_string_literal: true

class ClientsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @clients = Client.all
  end
end