Sequel.migration do
  change do
    add_index :pings, :created_at
  end
end
