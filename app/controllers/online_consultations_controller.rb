class OnlineConsultationsController < ApplicationController 
  before_action :authenticate_user!, except: [:index] 
  before_action :verify_user, only: [:show]
  
  def index 
    if current_user 
      @online_consultations = current_user.online_consultations
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
    puts "duration: #{duration}"
    booking_id = params[:booking_id]
    puts "online_booking_id: #{booking_id}"
    @booking = BookingDate.find(booking_id)
    start_time = @booking.start_time
    puts "start_time: #{start_time}"
    end_time = @booking.end_time
    date = @booking.date
    
    if duration == "30" 
      
      @online_consultation = OnlineConsultation.new(start_time: start_time, end_time: end_time, date: date, user_id: current_user.id)

      if @online_consultation.save 
        @booking.update(available: false)
        redirect_to online_consultations_path
        
      else 
        redirect_to online_consultations_path, status: :unprocessable_entity
      end
    elsif  duration == "60"
      end_time = (Time.parse(start_time) + 60.minutes).strftime("%H:%M") 
      puts "end_time: #{end_time}"
      @online_consultation2 = OnlineConsultation.new(start_time: start_time, end_time: end_time, date: date, user_id: current_user.id)
      next_slot = (Time.parse(start_time) + 30.minutes).strftime("%H:%M")
      puts "next_slot: #{next_slot}"
      @booking2 = BookingDate.find_by(start_time: next_slot, date: date)
      puts "booking2: #{@booking2}"
      if @online_consultation2.save 
        @booking2.update(available: false)
        @booking.update(available: false)
        flash[:notice] = "Your booking has been confirmed"
        redirect_to new_online_consultation_case_sheet_path(online_consultation_id: @online_consultation2.id)
      else  
        redirect_to online_consultations_path, status: :unprocessable_entity, notice: "Something went wrong"
      end  

    end 
  end 

  def destroy

  end

  private  

  def verify_user 
    @online_consultation = OnlineConsultation.find(params[:id])
    if @online_consultation.user != current_user
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
end 