class User < ActiveRecord::Base
  track :create, :destroy, update: :name
end
