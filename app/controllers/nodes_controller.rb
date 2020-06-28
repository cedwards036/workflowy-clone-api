class NodesController < ApplicationController
  before_action :set_node, only: [:show, :update, :destroy]

  def show
    render json: @node
  end

  def create
    if (params.has_key? :parent_id) && (params.has_key? :list_id)
      render json: { message: "A node cannot have both a parent node and a parent list" }, status: :bad_request
    else
      if params.has_key? :parent_id
        create_node_from_parent_node
      else 
        create_node_from_list
      end
      @node.save
      render json: @node, status: :created
    end
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

  def create_node_from_parent_node
    parent = Node.find(params[:parent_id])
    @node = parent.child_nodes.build(node_params)
  end

  def create_node_from_list
    list = List.find(params[:list_id])
    @node = list.nodes.build(node_params)
  end

  def node_params
    params.require(:node).permit(:text, :completed, :expanded)
  end

  def set_node
    @node = Node.find(params[:id])
  end
end
