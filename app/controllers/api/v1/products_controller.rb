class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_with_token!, only: %i[create update destory]
  def show
    render json: Product.find(params[:id])
  end

  def index
    products = if params[:product_ids].present?
                 Product.find(params[:product_ids])
               else
                 Product.all
               end
    render json: products
  end

  def create
    product = current_user.products.build(product_params)
    if product.save
      render json: product, status: :created, location: [:api, product]
    else
      render json: { errors: product.errors }, status: :unprocessable_entity
    end
  end

  def update
    product = current_user.products.find(params[:id])
    if product&.update(product_params)
      render json: product, status: :ok, location: [:api, product]
    else
      render json: { errors: product.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    product = current_user.products.find(params[:id])
    product.destroy
    head 204
  end
  
  private
  
  def product_params
    params.require(:product).permit(:title, :price, :published)
  end
end
