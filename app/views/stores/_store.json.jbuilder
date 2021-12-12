json.extract! store, :id, :name, :password_digest, :address, :joindate, :rating, :created_at, :updated_at
json.url store_url(store, format: :json)
