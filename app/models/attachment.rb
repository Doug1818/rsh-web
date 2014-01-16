class Attachment < ActiveRecord::Base
  belongs_to :small_step
  mount_uploader :filename, FileUploader
end
