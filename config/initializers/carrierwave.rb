CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: 'AKIAJ3MMJH4AZLJ4BRJA',
    aws_secret_access_key: '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'
  }
  config.fog_directory  = 'rsh-dev'
end
