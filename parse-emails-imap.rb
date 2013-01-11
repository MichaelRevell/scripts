# Script will search through all emails
# and extract your contact's names, email and phone number
# Then will export to cvs
require 'net/imap'
require 'csv'

HOST = "" # Enter your host name e.g. imap.gmail.com
PORT = 993 # Default port
USERNAME = "" # Email name. e.g. username@gmail.com
PASSWORD = ""

filename = "body.csv" # Filename to save file

messages = []

imap = Net::IMAP.new(HOST, 993, true)
imap.login(USERNAME, PASSWORD)
imap.examine('INBOX')

# Retreives contacts via email messages 
# And stores them in a hash array
imap.search(["SINCE", "10-Jan-1971"]).each do |message_id| # Search through all emails
    envelope = imap.fetch(message_id, 'ENVELOPE')[0].attr["ENVELOPE"]
    name = envelope.from[0].name
    email = envelope.from[0].mailbox + "@" + envelope.from[0].host
    body = imap.fetch(message_id,'BODY[TEXT]')[0].attr['BODY[TEXT]']
    phone_number = /\(?1?-?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})/.match(body)
    phone_number = phone_number.nil? ? "none" : phone_number[0]

    # Uncomment if you'd like to sort through contacts
    # puts "Body: #{body}"
    # puts "Name: #{name}, Email: #{email}, Phone_Number: #{phone_number}"
    # gets

    messages << [name, email, phone_number] #, body]
    # puts "[\"#{name}\", \"#{email}\", \"#{phone_number}\"], "
end

# Loops through has array and stores in a CSV file
CSV.open(filename, 'w') do |csv|
  csv << ['Name', 'Email', 'Phone Number']
  messages.each do |message|
    csv << [message[0], message[1], message[2]]
    # puts "Name: #{message[0]}, Email: #{message[1]},  Phone_Number: #{message[2]}"
  end
end
