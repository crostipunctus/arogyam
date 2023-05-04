require 'test_helper'

class CaseSheetsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.create!(email: 'test@example.com', password: 'password123')
    @user.confirm
    @online_consultation = OnlineConsultation.create!(user: @user,
      date: Date.today,
      start_time: "10:00",
      end_time: "12:00")
    @case_sheet = CaseSheet.create!(
      online_consultation: @online_consultation,
      vegetarian: true,
      height: "180",
      weight: "80",
      blood_group: "A+",
      appetite: "normal",
      sleep: "good",
      motion: "regular",
      energy_level: "high",
      hereditary_mother: "diabetes",
      hereditary_father: "hypertension",
      surgeries: "appendectomy",
      normal_deliveries: "2",
      caesarian_deliveries: "1",
      exercise_routine: "jogging, swimming",
      past_ailments: "chickenpox",
      present_complaints: "migraine"
    )
  end

  def teardown
    CaseSheet.where(online_consultation_id: @online_consultation.id).destroy_all
    @online_consultation.destroy
    @user.destroy
    
    
    
  end

  test 'should get new' do
    sign_in @user
    get new_online_consultation_case_sheet_path(@online_consultation)
    assert_response :success
  end

  test 'should create case_sheet' do
    sign_in @user
    assert_difference('CaseSheet.count') do
      post online_consultation_case_sheet_path(@online_consultation), params: {
        case_sheet: {
          vegetarian: true,
          height: "180",
          weight: "80",
          blood_group: "A+",
          appetite: "normal",
          sleep: "good",
          motion: "regular",
          energy_level: "high",
          hereditary_mother: "diabetes",
          hereditary_father: "hypertension",
          surgeries: "appendectomy",
          normal_deliveries: "2",
          caesarian_deliveries: "1",
          exercise_routine: "jogging, swimming",
          past_ailments: "chickenpox",
          present_complaints: "migraine"
        }
      }
    end
    assert_redirected_to online_consultation_path(@online_consultation)
    follow_redirect!
    assert_equal "Online consultation is confirmed!", flash[:notice]
  end

  test 'should get edit' do
    sign_in @user
    get edit_online_consultation_case_sheet_path(@online_consultation, @case_sheet)
    assert_response :success
  end

  test 'should update case_sheet' do
    sign_in @user
    patch online_consultation_case_sheet_path(@online_consultation, @case_sheet), params: {
      case_sheet: {
        vegetarian: true,
        height: "175",
        weight: "79",
        blood_group: "b+",
        appetite: "good",
        sleep: "good",
        motion: "regular",
        energy_level: "high",
        hereditary_mother: "diabetes",
        hereditary_father: "hypertension",
        surgeries: "appendectomy",
        normal_deliveries: "2",
        caesarian_deliveries: "1",
        exercise_routine: "jogging, swimming",
        past_ailments: "chickenpox",
        present_complaints: "migraine"
      }
    }
    assert_redirected_to online_consultation_path(@online_consultation)
    follow_redirect!
    assert_equal "Case sheet updated successfully", flash[:notice]
  end

  test 'should destroy case_sheet' do
    sign_in @user
    assert_difference('CaseSheet.count', -1) do
      delete online_consultation_case_sheet_path(@online_consultation)
    end
    assert_redirected_to online_consultations_path
    follow_redirect!
    assert_equal "Case sheet deleted successfully", flash[:notice]
  end
end
