class NodesController < ApplicationController
  before_action :set_node, only: [:show, :update, :destroy]

  def show
    render json: @node
  end

  def create
    parent = Node.find(params[:parent_id])
    @node = parent.child_nodes.build(node_params)
    @node.save
    render json: @node, status: :created
  end

  def update
    @node.update(node_params)
    head :no_content
  end

  def destroy
    @node.destroy
    head :no_content
  end

  private

  def node_params
    params.require(:node).permit(:text, :completed, :expanded)
  end

  def set_node
    @node = Node.find(params[:id])
  end
end
