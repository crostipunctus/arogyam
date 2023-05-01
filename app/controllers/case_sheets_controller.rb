class CaseSheetsController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def new
    @case_sheet = CaseSheet.new
  end

  def create
    online_consultation = current_user.online_consultations.first
    @case_sheet = CaseSheet.new(case_sheet_params)
    @case_sheet.online_consultation_id = online_consultation.id
    if @case_sheet.save
      online_consultation.update(confirmed: true)
      redirect_to online_consultation_path(online_consultation), notice: "Case sheet created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def case_sheet_params
    params.require(:case_sheet).permit(:online_consultation_id, :vegetarian, :height, :weight, :blood_group, :appetite, :sleep, :motion, :energy_level, :hereditary_mother, :hereditary_father, :surgeries, :normal_deliveries, :caesarian_deliveries, :exercise_routine, :past_ailments, :present_complaints, :confirmed)
  end
end
