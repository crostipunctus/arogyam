require "net/smtp"

class ConfirmationInstructionsJob < ApplicationJob
  queue_as :critical

  self.enqueue_after_transaction_commit = true
  self.log_arguments = false

  # Active Job owns the retry limit; exhausted jobs remain in Sidekiq's dead set.
  sidekiq_options retry: 0

  retry_on Net::OpenTimeout, Net::ReadTimeout, Net::WriteTimeout,
    Net::SMTPServerBusy, IOError, SocketError,
    Errno::ECONNRESET, Errno::ECONNREFUSED, Errno::ETIMEDOUT, Errno::EPIPE,
    wait: :polynomially_longer, attempts: 8

  discard_on ActiveJob::DeserializationError

  def perform(user, confirmation_token_digest:)
    return if user.confirmed? && !user.pending_reconfirmation?
    return unless current_confirmation?(user, confirmation_token_digest)

    options = user.pending_reconfirmation? ? { to: user.unconfirmed_email } : {}
    Devise.mailer.confirmation_instructions(user, user.confirmation_token, options).deliver_now
  end

  private

  def current_confirmation?(user, confirmation_token_digest)
    # Devise stores the confirmation token on the user. Queue only its digest,
    # so job payloads/error reports cannot expose the confirmation link.
    user.confirmation_token.present? &&
      Digest::SHA256.hexdigest(user.confirmation_token) == confirmation_token_digest
  end
end
