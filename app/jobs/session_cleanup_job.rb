class SessionCleanupJob < ApplicationJob
  queue_as :low

  BATCH_SIZE = 1_000
  MAX_SESSIONS_PER_RUN = 25_000
  DEFAULT_RETENTION_DAYS = 30

  def perform
    return unless cleanup_enabled?

    deleted_count = delete_expired_sessions
    Rails.logger.info("Session cleanup removed #{deleted_count} expired sessions")
  end

  private

  def cleanup_enabled?
    ActiveModel::Type::Boolean.new.cast(ENV["SESSION_CLEANUP_ENABLED"])
  end

  def delete_expired_sessions
    deleted_count = 0
    expiration_cutoff = retention_period.ago

    while deleted_count < MAX_SESSIONS_PER_RUN
      session_ids = expired_sessions(expiration_cutoff).limit(BATCH_SIZE).pluck(:id)
      break if session_ids.empty?

      deleted_count += session_model.where(id: session_ids, updated_at: ...expiration_cutoff).delete_all
    end

    deleted_count
  end

  def expired_sessions(expiration_cutoff)
    session_model.where(updated_at: ...expiration_cutoff).order(:updated_at)
  end

  def retention_period
    ENV.fetch("SESSION_DAYS_TRIM_THRESHOLD", DEFAULT_RETENTION_DAYS).to_i.clamp(1, 365).days
  end

  def session_model
    ActiveRecord::SessionStore::Session
  end
end
