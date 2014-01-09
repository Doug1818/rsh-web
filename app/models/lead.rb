class Lead < ActiveRecord::Base
	validates :name, presence: true
	validates :email, presence: true
	validates :email, uniqueness: true

	def save_with_mailchimp
		if self.save
			begin
	      gb = Gibbon::API.new(MAILCHIMP_API_KEY)
	      list_id = gb.lists.list({:filters => {:list_name => "Steps Leads"}})["data"].first["id"]
	      gb.lists.subscribe(:id => list_id, :email => {:email => self.email}, :merge_vars => {'NAME' => self.name}, :double_optin => false)
	    rescue Gibbon::MailChimpError => e
	      flash[:error] = e.message
	    end
    end
	end
end
