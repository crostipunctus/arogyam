class CaseSheetsController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def new
    @case_sheet = CaseSheet.new
    @online_consultation = OnlineConsultation.find(params[:online_consultation_id])
  end

  def create
    online_consultation = OnlineConsultation.find(params[:online_consultation_id])
    @case_sheet = CaseSheet.new(case_sheet_params)
    @case_sheet.online_consultation_id = online_consultation.id
    if @case_sheet.save
      OnlineConsultationMailer.online_consultation_confirmation_email(online_consultation).deliver_later
      OnlineConsultationMailer.online_consultation_user_confirmation_email(online_consultation).deliver_later
      online_consultation.update(status: "confirmed")
      online_consultation.update(confirmed: true)
      booking_date = BookingDate.find_by(date: online_consultation.date, start_time: online_consultation.start_time)
      booking_date.update(status: "confirmed")
      redirect_to online_consultation_path(online_consultation), notice: "Online consultation is confirmed!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    Rails.logger.info "params: #{params.inspect}"
    @online_consultation = OnlineConsultation.find(params[:online_consultation_id])
    @case_sheet = @online_consultation.case_sheet
  end

  def update
    @online_consultation = OnlineConsultation.find(params[:online_consultation_id])
    @case_sheet = @online_consultation.case_sheet
    if @case_sheet.update(case_sheet_params)
      redirect_to online_consultation_path(@case_sheet.online_consultation), notice: "Case sheet updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @online_consultation = OnlineConsultation.find(params[:online_consultation_id])
    @case_sheet = @online_consultation.case_sheet
    @case_sheet.destroy
    redirect_to online_consultations_path, notice: "Case sheet deleted successfully"
  end

  private

  def case_sheet_params
    params.require(:case_sheet).permit(:online_consultation_id, :vegetarian, :height, :weight, :blood_group, :appetite, :sleep, :motion, :energy_level, :hereditary_mother, :hereditary_father, :surgeries, :normal_deliveries, :caesarian_deliveries, :exercise_routine, :past_ailments, :present_complaints, :confirmed)
  end
end
