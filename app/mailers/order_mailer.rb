# frozen_string_literal: true

# Mailing
class OrderMailer < ApplicationMailer
  default from: 'Admin_Ecommerce@gmail.com'

  def order_confirmation
    @user = params[:user]

    mail(to: @user[:email], subject: 'You Have Successfully Ordered.')
  end
end
