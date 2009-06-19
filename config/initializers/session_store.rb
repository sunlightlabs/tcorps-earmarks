# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_tcorps-earmarks_session',
  :secret      => '0cd4043339906dad3eea1947e067d6ebb101facc9e483cf733ded05a3956aa9c1c1300488ed58fb308b5976d10b71e83f2a2e6df3c091f316124208746484667'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
