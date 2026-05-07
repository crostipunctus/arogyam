class Setting < ApplicationRecord
  after_save :clear_cache
  after_destroy :clear_cache

  def self.instance
    Rails.cache.fetch("site_settings", expires_in: 1.hour) { first_or_create! }
  end

  def whatsapp_enabled?
    whatsapp_number.present?
  end

  def whatsapp_chat_url
    return nil unless whatsapp_enabled?

    digits = whatsapp_number.to_s.gsub(/\D/, "")
    message = whatsapp_message.presence || "Hi ArogyaM, I'd like to know more about your wellness programmes."
    "https://wa.me/#{digits}?text=#{ERB::Util.url_encode(message)}"
  end

  private

  def clear_cache
    Rails.cache.delete("site_settings")
  end
end
