class UserMailer < ApplicationMailer
  default :from => 'elegy.notify@gmail.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_email(user, user_url)
    user.recipients.each do |recipient|
        @recipient = recipient
        @user = user
        @user_url = user_url
        mail( 
            :to => @recipient.email,
            :subject => 'Our Condolences'
        )
    end
  end
end
