class OnlineConsultationsController < ApplicationController 
  before_action :authenticate_user!, except: [:index] 
  before_action :set_online_consultation, only: [:show, :update, :destroy]
  before_action :verify_user, only: [:show]
  
  def index 
    case params[:filter]
    when 'all'
      @online_consultations = OnlineConsultation.all
    when 'confirmed'
      @online_consultations = OnlineConsultation.where(confirmed: true, completed: false)
    when 'unconfirmed'
      @online_consultations = OnlineConsultation.where(status: 'unconfirmed')
    when 'completed'
      @online_consultations = OnlineConsultation.where(completed: true)
    when 'payment_complete'
      @online_consultations = OnlineConsultation.where(payment_complete: true)
    when 'cancelled'
      @online_consultations = OnlineConsultation.where(cancelled: true)
    else
      @online_consultations = OnlineConsultation.all
    end
    start_date = params.fetch(:start_date, Date.today.strftime("%Y-%m-%d")).to_date rescue Date.today
    @calendar_start = start_date
    @calendar_end = start_date + 30.days
    @booking_dates = BookingDate.where(date: @calendar_start..@calendar_end)
    if current_user 
      @confirmed_online_consultations = current_user.online_consultations.where(confirmed: true, completed: false)
      @unconfirmed_online_consultations = current_user.online_consultations.where(status: "unconfirmed", completed: false, cancelled: false)
      @cancelled_online_consultations = current_user.online_consultations.where(cancelled: true)
      @slots = BookingDate.where(date: start_date..(start_date + 1.month))
    else  
      @slots = BookingDate.where(date: start_date..(start_date + 1.month)) 
    end 
  end 


  def show 
    @online_consultation = OnlineConsultation.find(params[:id])
    @case_sheet = @online_consultation.case_sheets.last
  end 

  def new
    @booking_date = BookingDate.new
  end 

  def create  
    booking_id = params[:booking_id]
    @booking = BookingDate.find(booking_id)
    start_time = @booking.start_time
    end_time = @booking.end_time
    date = @booking.date

    @online_consultation = OnlineConsultation.new(start_time: start_time, end_time: end_time, date: date, user_id: current_user.id, booking_date_id: @booking.id)
    if @online_consultation.save 
      OnlineConsultationMailer.online_consultation_email(@online_consultation).deliver_later
      OnlineConsultationMailer.online_consultation_user_confirmation_email(@online_consultation).deliver_later
      @booking.update(available: false, status: "unconfirmed")
      @online_consultation.update(status: "unconfirmed")
      if !current_user.case_sheets.exists?
        redirect_to new_online_consultation_case_sheet_path(@online_consultation)
      else 
      redirect_to online_consultations_path
      end
    else 
      redirect_to online_consultations_path, status: :unprocessable_entity
    end
  end 

  def edit 
    @online_consultation = OnlineConsultation.find(params[:id])
    @slots = BookingDate.where(available: true)
  end 

  def reschedule 
    @online_consultation = OnlineConsultation.find(params[:id])
    @old_booking_date = @online_consultation.booking_date
    booking_id = params[:booking_id]
    @booking = BookingDate.find(booking_id)
    start_time = @booking.start_time
    end_time = @booking.end_time
    date = @booking.date

    @online_consultation.update(start_time: start_time, end_time: end_time, date: date, booking_date_id: @booking.id)
    @old_booking_date.update(available: true)
    if @booking.update(available: false)
      OnlineConsultationMailer.online_consultation_reschedule_email(@online_consultation).deliver_later
      OnlineConsultationMailer.online_consultation_reschedule_user_email(@online_consultation).deliver_later

      redirect_to online_consultations_path, notice: "Consultation rescheduled succesfully"
    else
      redirect_to online_consultations_path, notice: "Something went wrong", status: :unprocessable_entity
    end
  end 

  def update 
    @online_consultation = OnlineConsultation.find(params[:id])
    if @online_consultation.confirmed == true 
      @online_consultation.update(completed: true, status: "completed", confirmed: false )
      @online_consultation.booking_date.update(available: true)
      redirect_to registrations_path, notice: "Your booking has been completed"
    else
      @online_consultation.update(confirmed: true, status: "confirmed")
      last_case_sheet = CaseSheet.where(user_id: current_user.id).last
      last_case_sheet.update(online_consultation_id: @online_consultation.id)
      OnlineConsultationMailer.review_consultation_email(@online_consultation).deliver_later

      redirect_to online_consultations_path, notice: "Your booking has been confirmed"
    end

    # ADD OnlineConsultationMailer.online_consultation_completed_email(@online_consultation).deliver_later
  end 



  def payment_complete 
    @online_consultation = OnlineConsultation.find(params[:id])
    if @online_consultation.payment_complete == true
      @online_consultation.update(payment_complete: false)
    else
      @online_consultation.update(payment_complete: true)
      OnlineConsultationMailer.online_consultation_payment_confirmation_email(@online_consultation).deliver_later
      OnlineConsultationMailer.online_consultation_payment_user_confirmation_email(@online_consultation).deliver_later
    end
    redirect_to registrations_path, notice: "Your booking has been confirmed"
  end 

  def destroy
      
    @booking = @online_consultation.booking_date
    @booking.update(available: true)
      
    @online_consultation.update(cancelled: true, status: "cancelled", confirmed: false, completed: false ) 
    

    OnlineConsultationMailer.online_consultation_user_cancellation_email(@online_consultation).deliver_later
    redirect_to online_consultations_path, notice: "Your booking has been cancelled"
  end

  private  

  def online_consultation_params 
    params.require(:online_consultation).permit(:start_time, :end_time, :date, :user_id, :booking_date_id, :status, :confirmed, :completed, :cancelled, :payment_complete)
  end 
  

  def set_online_consultation
    @online_consultation = OnlineConsultation.find(params[:id])
  end

  def verify_user
    if current_user.admin?
      true
    elsif @online_consultation.user != current_user
      redirect_to root_path, alert: "You are not authorized to access this page."
    else  
      true 
    end
  end
  
end 