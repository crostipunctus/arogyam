class OnlineConsultationsController < ApplicationController 
  before_action :authenticate_user!, except: [:index] 
  before_action :set_online_consultation, only: [:show, :update, :destroy]
  before_action :verify_user, only: [:show]
  
  def index 
    if current_user 
      @online_consultations = current_user.online_consultations.where.not(status: "cancelled")
      @slots = if params[:slot_duration].to_i == 60
        BookingDate.where(start_time: ["14:00", "15:00"])
      else
        BookingDate.all
      end
    else  
      @slots = if params[:slot_duration].to_i == 60
        BookingDate.where(start_time: ["14:00", "15:00"])
      else
        BookingDate.all
      end
    end 
  
  end 


  def show 
    @online_consultation = OnlineConsultation.find(params[:id])
    @case_sheet = @online_consultation.case_sheet
  end 

  def new
    @booking_date = BookingDate.new
  end 

  def create  
    duration = params[:slot_duration]
    booking_id = params[:booking_id]
    @booking = BookingDate.find(booking_id)
    start_time = @booking.start_time
    end_time = @booking.end_time
    date = @booking.date

    if duration == "30" 
      
      @online_consultation = OnlineConsultation.new(start_time: start_time, end_time: end_time, date: date, user_id: current_user.id, duration: "30")
      if @online_consultation.save 
        OnlineConsultationMailer.online_consultation_email(@online_consultation).deliver_later

        @booking.update(available: false)
       
        redirect_to online_consultations_path
      else 
        redirect_to online_consultations_path, status: :unprocessable_entity
      end
    elsif  duration == "60"
      end_time = (Time.parse(start_time) + 60.minutes).strftime("%H:%M") 
      @online_consultation2 = OnlineConsultation.new(start_time: start_time, end_time: end_time, date: date, user_id: current_user.id, duration: "60")
      next_slot = (Time.parse(start_time) + 30.minutes).strftime("%H:%M")
      @booking2 = BookingDate.find_by(start_time: next_slot, date: date)
      if @online_consultation2.save 
        OnlineConsultationMailer.online_consultation_email(@online_consultation2).deliver_later
        @booking2.update(available: false)
        @booking.update(available: false)
        flash[:notice] = "Your booking has been confirmed"
        redirect_to online_consultations_path
      else  
        redirect_to online_consultations_path, status: :unprocessable_entity, notice: "Something went wrong"
      end 
    else   
      redirect_to online_consultations_path, status: :unprocessable_entity, notice: "Something went wrong"
    end 
  end 

  def update 
    
    respond_to do |format|
      if @online_consultation.update(status: params[:online_consultation][:status])
        format.json { render json: { status: :ok, message: "Registration was successfully updated." } }
      else
        
        format.json { render json: { status: :unprocessable_entity, message: "Failed to update Vishraam registration.", errors: @online_consultation.errors.full_messages } }
      end
    end
  end 

  def destroy
    
      if @online_consultation.duration == "30"
        @booking = BookingDate.find_by(date: @online_consultation.date, start_time: @online_consultation.start_time)
        @booking.update(available: true)
      elsif @online_consultation.duration == "60"  
        @booking = BookingDate.find_by(date: @online_consultation.date, start_time: @online_consultation.start_time)
        @booking.update(available: true)
        next_slot = (Time.parse(@online_consultation.start_time) + 30.minutes).strftime("%H:%M")
        @booking2 = BookingDate.find_by(start_time: next_slot, date: @online_consultation.date)
        @booking2.update(available: true)
      end 
    @online_consultation.update(status: "cancelled" ) 
    OnlineConsultationMailer.online_consultation_user_cancellation_email(@online_consultation).deliver_later
    redirect_to online_consultations_path
  end

  private  
  

  def set_online_consultation
    @online_consultation = OnlineConsultation.find(params[:id])
  end

  def verify_user 
    
    if @online_consultation.user != current_user
      redirect_to root_path, alert: "You are not authorized to access this page."
    else  
      true 
    end
  end
end 