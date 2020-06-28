class ListsController < ApplicationController
  before_action :set_list, only: [:show]

  def show
    render json: @list, status: :ok
  end

  private

  def set_list
    @list = List.find(params[:id])
  end
end
