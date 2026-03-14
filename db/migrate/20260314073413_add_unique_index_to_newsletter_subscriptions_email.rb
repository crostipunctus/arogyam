class AddUniqueIndexToNewsletterSubscriptionsEmail < ActiveRecord::Migration[7.0]
  def change
    add_index :newsletter_subscriptions, :email, unique: true
  end
end
