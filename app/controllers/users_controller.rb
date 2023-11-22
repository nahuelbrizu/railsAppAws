class UsersController < ApplicationController
  def create
    # Create a new user and obtain their data
    user_data = { name: 'John Doe', email: 'johndoe@example.com' }
    uid = 'unique_user_id'  # Replace with the actual user's UID

    # Initialize the Firebase service
    firebase_service = FirebaseService.new

    # Save the user data to Firebase Realtime Database
    firebase_service.save_user_data(uid, user_data)

  end
end
