if Rails.env.production?
  ENV["TV_API_KEY"] = "REPLACE ME"
  ENV["TV_A_VAULT_ID"] = "REPLACE ME"
  ENV["TV_ACCOUNT_ID"] = "REPLACE ME"
else
  ENV["TV_API_KEY"] = "97166912-ee2b-42d0-a877-764e52c971d5"
  ENV["TV_A_VAULT_ID"] = "a4cc5ae7-1582-4807-9591-34175264aadb"
  ENV["TV_ACCOUNT_ID"] = "ae8b9fee-e5bd-4fea-ba60-708564017f5d"
end
