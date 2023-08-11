#!/usr/bin/python3

# script to send mail via external email server
# (do NOT name this script "smtplib.py")

# edit settings
debuglevel   = 0
server_host  = 'SMTP server ip'
server_port  = 587
server_user  = 'your_email@mail.com'
server_pass  = 'email password'
address_from = 'your_email@mail.com'
address_to   = 'your_email2@mail.com'
#Message body file path, same as in cpu_monitor.sh
file_path    = '/tmp/Mail.out'

# load requirements
import datetime
import smtplib
import sys

# format mailheader

# get subject line as argument
try:
    sys.argv[1]
except IndexError:
    mail_subject = "ATTENTION: CPU load is high on sportshare server"
else:
    mail_subject = " ".join(sys.argv[1:])

# read file for message body
with open(file_path, 'r') as file: 
    msg_content = file.read()

msg_from = "From: " + address_from + "\r\n"
msg_to = "To: " + address_to + "\r\n"
msg_subject = "Subject: " + mail_subject + "\r\n"
msg_timestamp = '{:%a, %d %b %Y %H:%M:%S %z}'.format(datetime.datetime.now())
msg_date = "Date: " + msg_timestamp + "\r\n"
msg = msg_from + msg_to + msg_subject + msg_date + "\r\n" + msg_content

# connect to email server, login, send mail and disconnect
server = smtplib.SMTP(server_host, server_port)
server.ehlo()
server.starttls()
server.login(server_user, server_pass)
server.set_debuglevel(debuglevel)
server.sendmail(address_from, address_to, msg)
server.rset()
server.quit()