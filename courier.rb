require 'sinatra'
require 'pony'

configure do
  Pony.mail(:to => 'svenhenson@gmail.com', :via => :smtp, :via_options => {
      :address        => 'smtp.sendgrid.net',
      :port           => '25',
      :authentication => :plain,
      :user_name      => ENV['SENDGRID_USERNAME'],
      :password       => ENV['SENDGRID_PASSWORD'],
      :domain         => ENV['SENDGRID_DOMAIN']
    }
end

post '/' do
  name, email, message = params[:name], params[:email], params[:message]
  
  Pony.mail(:from => email, :subject => 'Webform submission', :body => message)
  
end