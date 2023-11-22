require 'firebase-admin-sdk'

class FirebaseService
  def initialize
    config = {
      database_url: 'freefood-81e31.firebaseapp.com',
      json_key_io: File.open('config/firebase_setting.json')
    }
    @firebase = FirebaseAdmin::Client.new(config)
  end

  def save_user_data(uid, user_data)
    # Save user data to Firebase Realtime Database
    @firebase.set("users/#{uid}", user_data)
  end
end
