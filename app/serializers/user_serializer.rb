class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :created_at, :updated_at, :auth_token
  attribute :product_ids do
    object.products.map(&:id)
  end
end
