class Security

  def self.generate_token
    SecureRandom.urlsafe_base64
  end
end
