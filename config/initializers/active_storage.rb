# config/initializers/active_storage.rb
#
# Default attachment URL routing: redirect to the storage backend (S3) rather
# than proxy bytes through Rails. Every hot-path view explicitly uses
# `rails_public_blob_url` to hit CloudFront directly, but a few code paths
# (notably Action Text's default `_blob.html.erb` partial used by RichText)
# still resolve attachments through this default. Redirect mode keeps those
# requests off the Passenger workers.
Rails.application.config.active_storage.resolve_model_to_route = :rails_storage_redirect
