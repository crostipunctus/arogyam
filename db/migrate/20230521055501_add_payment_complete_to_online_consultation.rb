class AddPaymentCompleteToOnlineConsultation < ActiveRecord::Migration[7.0]
  def change
    add_column :online_consultations, :payment_complete, :boolean, default: false
  end
end
