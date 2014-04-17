if Rails.env.production?
  ENV["TV_API_KEY"] = "REPLACE ME"
  ENV["TV_A_VAULT_ID"] = "REPLACE ME"
  ENV["TV_ACCOUNT_ID"] = "REPLACE ME"
else
  ENV["TV_API_KEY"] = "b81bc26a-df6b-4d05-a0e5-ef20bae10e1e"
  ENV["TV_A_VAULT_ID"] = "5c10ffce-83b0-4bfa-b2c0-8bcb94a0c5c7"
  ENV["TV_ACCOUNT_ID"] = "1ff7e16e-68cd-4c81-8510-a106d3cf96a6"
end
