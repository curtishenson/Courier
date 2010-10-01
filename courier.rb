require 'sinatra'
require 'pony'

EMAIL_EX = /^[-a-z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.(aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?$/i
@@url = 'http://curtishenson.com/contact'

error do
  'Sorry there was an error - ' + env['sinatra.error'].name
end

post '/' do
  error = false;
  name, email, message = params[:name], params[:email], params[:message]
  
  error = true if email[EMAIL_EX].nil? || name.blank? || message.blank?
  puts "#{name} -- #{email} -- #{message}"
  if error == false
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
    
    redirect "#{@@url}/success/"
  else
    redirect "#{@@url}/error/"
  end
  
end