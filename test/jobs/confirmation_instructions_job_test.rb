require "test_helper"
require "minitest/mock"

class ConfirmationInstructionsJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  setup do
    ActionMailer::Base.deliveries.clear
    @user = User.new(email: "confirmation@example.com", password: "password123", privacy_policy: "1")
    @user.skip_confirmation_notification!
    @user.save!
    @user = User.find(@user.id)
  end

  teardown do
    ActionMailer::Base.deliveries.clear
  end

  test "a temporary delivery failure retries and sends a working confirmation link" do
    @user.send_confirmation_instructions
    original_token = @user.confirmation_token

    with_delivery_error(Net::OpenTimeout) do
      assert_enqueued_with(job: ConfirmationInstructionsJob, queue: "critical", at: ->(time) { time > Time.current }) do
        ActiveJob::Base.execute(enqueued_jobs.shift)
      end
    end

    assert_empty ActionMailer::Base.deliveries
    assert_not @user.reload.confirmed?

    assert_emails 1 do
      perform_enqueued_jobs(only: ConfirmationInstructionsJob)
    end

    email = ActionMailer::Base.deliveries.last
    assert_equal [@user.email], email.to
    assert_includes email.body.decoded, original_token
    assert User.confirm_by_token(original_token).confirmed?
  end

  test "temporary failures stop after eight attempts" do
    @user.send_confirmation_instructions

    with_delivery_error(Net::SMTPServerBusy) do
      7.times do
        ActiveJob::Base.execute(enqueued_jobs.shift)
        assert_enqueued_jobs 1, only: ConfirmationInstructionsJob
      end

      assert_raises(Net::SMTPServerBusy) do
        ActiveJob::Base.execute(enqueued_jobs.shift)
      end
    end

    assert_no_enqueued_jobs only: ConfirmationInstructionsJob
    assert_equal 0, ConfirmationInstructionsJob.get_sidekiq_options["retry"]
  end

  test "permanent SMTP rejection is surfaced without automatic retries" do
    @user.send_confirmation_instructions

    with_delivery_error(Net::SMTPFatalError) do
      assert_raises(Net::SMTPFatalError) do
        ActiveJob::Base.execute(enqueued_jobs.shift)
      end
    end

    assert_no_enqueued_jobs only: ConfirmationInstructionsJob
  end

  test "pending confirmation jobs stop after the user confirms" do
    @user.send_confirmation_instructions
    @user.confirm

    assert_no_emails do
      perform_enqueued_jobs(only: ConfirmationInstructionsJob)
    end
  end

  test "an email change skips the old token and confirms the new address" do
    @user.send_confirmation_instructions
    old_token = @user.confirmation_token
    @user.confirm
    @user.update!(email: "changed@example.com")

    assert_emails 1 do
      perform_enqueued_jobs(only: ConfirmationInstructionsJob)
    end

    email = ActionMailer::Base.deliveries.last
    assert_equal ["changed@example.com"], email.to
    assert_not_equal old_token, @user.confirmation_token
    assert_includes email.body.decoded, @user.confirmation_token
    assert_equal "changed@example.com", User.confirm_by_token(@user.confirmation_token).email
  end

  test "jobs for deleted accounts are discarded" do
    @user.send_confirmation_instructions
    @user.destroy!

    assert_no_emails do
      perform_enqueued_jobs(only: ConfirmationInstructionsJob)
    end
    assert_no_enqueued_jobs only: ConfirmationInstructionsJob
  end

  test "confirmation tokens are absent from serialized job arguments" do
    @user.send_confirmation_instructions

    assert_no_match @user.confirmation_token, enqueued_jobs.first.to_json
  end

  test "a resend inside a rolled back transaction is not queued" do
    assert_no_enqueued_jobs only: ConfirmationInstructionsJob do
      User.transaction do
        @user.send_confirmation_instructions
        assert_no_enqueued_jobs only: ConfirmationInstructionsJob
        raise ActiveRecord::Rollback
      end
    end
  end

  private

  def with_delivery_error(error_class)
    delivery = Mail::TestMailer.new({})
    delivery.stub(:deliver!, ->(*) { raise error_class, "simulated mail server failure" }) do
      Mail::TestMailer.stub(:new, delivery) { yield }
    end
  end
end
