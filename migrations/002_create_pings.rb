Sequel.migration do
  change do
    create_table :pings do
      primary_key :id
      foreign_key :server_id, :servers, index: true, null: false
      Float :ping_time
      Time :created_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
