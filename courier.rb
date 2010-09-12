require 'sinatra'
require 'pony'

error do
  'Sorry there was an error - ' + env['sinatra.error'].name
end

post '/' do
  name, email, message = params[:name], params[:email], params[:message]
  
  Pony.mail(
    :to => 'svenhenson@gmail.com', 
    :from => email, 
    :subject => 'Webform submission', 
    :body => message, 
    :via => :smtp, 
    :via_options => {
        :address        => 'smtp.sendgrid.net',
        :port           => '25',
        :authentication => :plain,
        :user_name      => ENV['SENDGRID_USERNAME'],
        :password       => ENV['SENDGRID_PASSWORD'],
        :domain         => ENV['SENDGRID_DOMAIN']
    }
  )
  
  redirect 'http://localhost:4000/contact/'
  
end