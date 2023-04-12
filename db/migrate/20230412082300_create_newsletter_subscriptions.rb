class CreateNewsletterSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :newsletter_subscriptions do |t|
      t.string :email

      t.timestamps
    end
  end
end
