class MailchimpService
  def initialize(email)
    @email = email
    @list_id = "5b6215d26b"
  end

  def subscribe
    member_id = Digest::MD5.hexdigest(@email.downcase)
    response = Gibbon::Request.lists(@list_id).members(member_id).upsert(body: {email_address: @email, status: "subscribed"})
    response
  end
end
