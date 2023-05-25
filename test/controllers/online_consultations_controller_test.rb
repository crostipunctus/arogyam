require 'test_helper'

class OnlineConsultationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @user = User.create(email: "user@example.com", password: "password", password_confirmation: "password")
    @user.confirm
    @admin = User.create(email: "admin@example.com", password: "password", password_confirmation: "password", admin: true)
    @admin.confirm
    @online_consultation = OnlineConsultation.create(start_time: "10:00", end_time: "10:30", date: Date.today, user_id: @user.id, duration: "30")
    @case_sheet = CaseSheet.create!(
      vegetarian: true,
      height: '5ft 6in',
      weight: '60kg',
      blood_group: 'A+',
      appetite: 'Normal',
      sleep: 'Good',
      motion: 'Regular',
      energy_level: 'High',
      hereditary_mother: 'Diabetes',
      hereditary_father: 'Hypertension',
      surgeries: 'Appendectomy',
      normal_deliveries: '1',
      caesarian_deliveries: '0',
      exercise_routine: 'Running, Yoga',
      past_ailments: 'Chickenpox',
      present_complaints: 'Back pain',
      online_consultation_id: @online_consultation.id
    )
    @booking_date = BookingDate.create(start_time: "10:00", end_time: "10:30", date: Date.today, available: true)
    @online_consultation.update(user: @user)
    
  end

  

  test "should get index" do
    get online_consultations_url
    assert_response :success
  end

  test "should get index for signed-in user" do
    sign_in @user
    get online_consultations_url
    assert_response :success
  end
  

  test "should get show for owner" do
    sign_in @user
    get online_consultation_url(@online_consultation)
    assert_response :success
  end

  test "should redirect to root_path for non-owner" do
    other_user = User.create(email: "other@example.com", password: "password", password_confirmation: "password")
    other_user.confirm
    sign_in other_user

    get online_consultation_url(@online_consultation)
    assert_redirected_to root_path
    assert_equal "You are not authorized to access this page.", flash[:alert]
  end

  
  test "should create online consultation with 30 minute duration" do
    sign_in @user
    booking_id = @booking_date.id
    assert_difference('OnlineConsultation.count') do
      post online_consultations_url, params: { slot_duration: "30", booking_id: booking_id }
    end
    assert_redirected_to online_consultations_url
    assert_equal false, BookingDate.find(booking_id).available
  end

  test "should create online consultation with 60 minute duration" do
    sign_in @user
    booking_id = @booking_date.id
    booking2 = BookingDate.create(start_time: "10:30", end_time: "11:00", date: Date.today, available: true)

    assert_difference('OnlineConsultation.count') do
      post online_consultations_url, params: { slot_duration: "60", booking_id: booking_id }
    end
    assert_redirected_to online_consultations_url
    assert_equal false, BookingDate.find(booking_id).available
    assert_equal false, BookingDate.find(booking2.id).available
  end
  test "should not create online consultation with invalid duration" do
    sign_in @user
    booking_id = @booking_date.id

    assert_no_difference('OnlineConsultation.count') do
      post online_consultations_url, params: { slot_duration: "45", booking_id: booking_id }
    end
    assert_response :unprocessable_entity
  end

  test "should cancel online consultation with 30 minute duration" do
    sign_in @user
    online_consultation = OnlineConsultation.create(start_time: "10:00", end_time: "10:30", date: Date.today, user_id: @user.id, duration: "30")
    booking_id = @booking_date.id

    delete online_consultation_url(online_consultation)

    assert_redirected_to online_consultations_url
    assert_equal "cancelled", online_consultation.reload.status
    assert_equal true, BookingDate.find(booking_id).available
  end

  test "should cancel online consultation with 60 minute duration" do
    sign_in @user
    online_consultation = OnlineConsultation.create(start_time: "10:00", end_time: "11:00", date: Date.today, user_id: @user.id, duration: "60")
    booking_id = @booking_date.id
    booking2 = BookingDate.create(start_time: "10:30", end_time: "11:00", date: Date.today, available: false)

    delete online_consultation_url(online_consultation)

    assert_redirected_to online_consultations_url
    assert_equal "cancelled", online_consultation.reload.status
    assert_equal true, BookingDate.find(booking_id).available
    assert_equal true, BookingDate.find(booking2.id).available
  end



  # Add tests for other actions (new, create, update, destroy)
end