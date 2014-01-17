CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: 'AKIAJVTVIWXJEUZHYSSQ',
    aws_secret_access_key: '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'
  }
  config.fog_directory  = 'rsh-steps'
end
