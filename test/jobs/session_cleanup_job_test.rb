require "test_helper"

class SessionCleanupJobTest < ActiveJob::TestCase
  setup do
    @original_cleanup_setting = ENV["SESSION_CLEANUP_ENABLED"]
  end

  teardown do
    ENV["SESSION_CLEANUP_ENABLED"] = @original_cleanup_setting
  end

  test "does nothing unless session cleanup is explicitly enabled" do
    ENV.delete("SESSION_CLEANUP_ENABLED")
    expired_session = create_session(updated_at: 31.days.ago)

    SessionCleanupJob.perform_now

    assert ActiveRecord::SessionStore::Session.exists?(expired_session.id)
  end

  test "deletes expired sessions but preserves active sessions when enabled" do
    ENV["SESSION_CLEANUP_ENABLED"] = "true"
    expired_session = create_session(updated_at: 31.days.ago)
    active_session = create_session(updated_at: 29.days.ago)

    SessionCleanupJob.perform_now

    refute ActiveRecord::SessionStore::Session.exists?(expired_session.id)
    assert ActiveRecord::SessionStore::Session.exists?(active_session.id)
  end

  private

  def create_session(updated_at:)
    ActiveRecord::SessionStore::Session.create!(
      session_id: SecureRandom.hex(16),
      data: "",
      created_at: updated_at,
      updated_at: updated_at
    )
  end
end
