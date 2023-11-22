#app/models/user.rb
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth.info.name
      user.avatar_url = auth.info.image
      user.uid = auth.info.uid
      user.provider = auth.provider
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation
      unless user
             user = User.create(
               email:  auth.info.email,
               password: Devise.friendly_token[0,20],
               full_name:auth.info.name,
               avatar_url: auth.info.image,
               uid: auth.info.uid,
               provider: auth.provider,
             )
           end
       user
    end
  end


end
