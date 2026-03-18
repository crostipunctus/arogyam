module RegistrationsHelper
  def consultation_status_class(consultation)
    if consultation.status == 'confirmed'
      'bg-success'
    elsif consultation.status == 'cancelled'
      'bg-danger'
    elsif consultation.status == 'unconfirmed' || consultation.completed
      'bg-warning'
    else
      ''
    end
  end

  def registration_end_date(registration)
    registration.batch.start_date + registration.package.duration.to_i
  end

  def registration_status_badge_class(status)
    case status
    when 'Registered'      then 'info'
    when 'Payment Completed' then 'success'
    when 'Payment Pending'   then 'warning'
    when 'Completed'         then 'primary'
    when 'Cancelled'         then 'danger'
    else 'secondary'
    end
  end
end
