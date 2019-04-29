Sequel.migration do
  change do
    create_table :servers do
      primary_key :id
      inet :ip_address, null: false, index: true, unique: true
      FalseClass :enabled, default: false
    end
  end
end
