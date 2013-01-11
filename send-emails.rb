require 'net/smtp'

#Net::SMTP.enable_tls() 
EMAIL_SERVER = "" # Your email server
WEB_ADDRESS = "" # Website url
FROM_EMAIL = "" # Your email
PASSWORD = "" # Your Password
emails = [] # A hash of emails. Name, email



Net::SMTP.start(EMAIL_SERVER, 80, WEB_ADDRESS, FROM_EMAIL, PASSWORD, :plain) do |smtp| #emails.each do |e|
	(0...emails.length).each do |x|
		e = emails[x]
		full_name = e[0]
		first_name = /\w*/.match(e[0])[0].capitalize
		email = e[1]
msgstr = <<END_OF_MESSAGE
From: Office Hours <#{FROM_EMAIL}>
To: #{full_name} <#{email}>
Subject: Re\: [commercial] opportunity in online education
#{first_name},

Your message.

Thank,
Your Namme

END_OF_MESSAGE
	  	smtp.send_message msgstr, FROM_EMAIL, email # Sends the email
	  	puts "Sent to #{full_name} <#{email}> as #{first_name}"
	end
end
