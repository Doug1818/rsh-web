require 'truevault'

class User < ActiveRecord::Base
  STATUSES = { invited: 0, inactive: 1, active: 2 }
  GENDERS = ['', "Male", "Female"]

  before_create :set_invited_status

  before_update :handle_hipaa

  has_many :programs
  has_many :coaches, through: :programs
  has_many :alerts, through: :programs

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :full_name, presence: true, :on => :create, unless: :hipaa_compliant?

  mount_uploader :avatar, AvatarUploader

  attr_reader :full_name

  def password_required?
    if new_record?
      false
    else
      (self.password_confirmation.present? || (self.status == 'invited')) ? super : false
    end
  end

  def full_name
    if first_name.present? && last_name.present?
      "#{first_name} #{last_name}"
    end
  end

  def full_name=(full_name)
    if full_name.present?
      (self.first_name, self.last_name) = full_name.split(" ")
    end
  end

  def set_invited_status
    self.status = STATUSES[:invited]
  end

  def email_required?
    hipaa_compliant? ? false : true
  end

  def clear_pii
    self.first_name = nil
    self.last_name = nil
    self.email = nil
  end


  def get_pii
    response = {}

    if hipaa_compliant? and tv_id.present?
      tv = TrueVault::Client.new(ENV["TV_API_KEY"], ENV["TV_ACCOUNT_ID"], 'v1')
      response = tv.get_document(ENV["TV_A_VAULT_ID"], tv_id) || {}
    end

    response
  end

  def create_on_truevault
    tv = TrueVault::Client.new(ENV["TV_API_KEY"], ENV["TV_ACCOUNT_ID"], 'v1')
    tv_response = tv.create_document(ENV["TV_A_VAULT_ID"], tv_data)
    self.tv_id = tv_response["document_id"]
  end

  def update_on_truevault
    require 'truevault'
    tv = TrueVault::Client.new(ENV["TV_API_KEY"], ENV["TV_ACCOUNT_ID"], 'v1')
    tv.update_document(ENV["TV_A_VAULT_ID"], tv_id, tv_data)
  end

  def handle_hipaa
    if hipaa_compliant?
      if tv_id.nil?
        create_on_truevault
      else
        update_on_truevault
      end
      clear_pii
    end
  end

  def image_data=(data)
    io = CarrierwaveStringIO.new(Base64.decode64(data))
    self.avatar = io
  end

  private

  def tv_data
    { first_name: first_name, last_name: last_name, email: email, phone: phone }
  end
end
