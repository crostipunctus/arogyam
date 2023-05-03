require 'test_helper'

class BatchTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(first_name: 'John', last_name: "Doe", email: 'john@example.com')
    @batch = Batch.create!(start_date: Date.today, end_date: Date.today, duration: "5", name: "Test Batch")
    @registration = Registration.create!(batch: @batch, user: @user)
  end

  test 'calculate_duration should set the correct duration' do
    assert_equal 5, @batch.duration
  end


  test 'associations with registrations and users' do
    assert_respond_to @batch, :registrations
    assert_respond_to @batch, :users
    assert_includes @batch.users, @user
  end
end
