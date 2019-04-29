class Server < Sequel::Model
  plugin :update_or_create
  one_to_many :pings
end
