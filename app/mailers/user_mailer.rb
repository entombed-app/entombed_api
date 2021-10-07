class UserMailer < ApplicationMailer
  default :from => 'elegy.notify@gmail.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_email(user, user_url)
    user.recipients.each do |recipient|
        @recipient = recipient
        @user = user
        @executor = user.executors.first
        @user_url = user_url
        mail( 
            :to => @recipient.email,
            :subject => 'Our Condolences') do |format|
              format.html {render 'send_email' }
              format.text { render 'send_plain_email'}
            end
    end
  end
end
