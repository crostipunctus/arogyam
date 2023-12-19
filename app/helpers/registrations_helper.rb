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
end
