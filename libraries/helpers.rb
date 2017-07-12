include Chef::Mixin::PowershellOut

module Tools
  require 'net/smtp'
  require 'net/http'
  require 'json'  

  # Method to fetch data in JSON format from an URL
  def self.fetch(url)
    resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body
    return JSON.parse(data)
  end

  # Method to unindent multiline strings
  def self.unindent(string)
    first = string[/\A\s*/]
    string.gsub /^#{first}/, ''
  end

  # Method to send emails with attachment via smtp
  def self.send_email(to, opts={})
    opts[:server]      ||= 'smtp.office365.com'
    opts[:port]        ||= 587
    opts[:from]        ||= 'barcoder@redsis.com'
    opts[:password]    ||= 'Orion2015'
    opts[:from_alias]  ||= 'Chef Reporter'
    opts[:subject]     ||= "Chef Run on Node #{Chef.run_context.node.name}"
    opts[:message]     ||= '...'

    filename = "C:\\chef\\log-#{Chef.run_context.node.name}"
    # Read a file and encode it into base64 format
    encodedcontent = [File.read(filename)].pack("m")   # base64

    marker = "AUNIQUEMARKER"

    # Define the main headers.
    header = <<-HEADER
      From: #{opts[:from_alias]} <#{opts[:from]}>
      To: <#{to}>
      Subject: #{opts[:subject]}
      MIME-Version: 1.0
      Content-Type: multipart/mixed; boundary=#{marker}
      --#{marker}
    HEADER

    # Define the message action
    body = <<-BODY
      Content-Type: text/plain
      Content-Transfer-Encoding:8bit

      #{opts[:message]}
      --#{marker}
    BODY

    # Define the attachment section
    attached = <<-ATTACHED
      Content-Type: multipart/mixed; name=\"#{filename}\"
      Content-Transfer-Encoding:base64
      Content-Disposition: attachment; filename="#{filename}"

      #{encodedcontent}
      --#{marker}--
    ATTACHED

    mailtext = unindent header + body + attached

    smtp = Net::SMTP.new(opts[:server], opts[:port])
    smtp.enable_starttls_auto
    smtp.start(opts[:server], opts[:from], opts[:password], :login)
    smtp.send_message(mailtext, opts[:from], to)
    smtp.finish
  end

  # Method to send simple emails via smtp
  def self.simple_email(to, opts={})

    opts[:server]      ||= 'smtp.office365.com'
    opts[:port]        ||= 587
    opts[:from]        ||= 'barcoder@redsis.com'
    opts[:password]    ||= 'Orion2015'
    opts[:from_alias]  ||= 'Chef Reporter'
    opts[:subject]     ||= "Chef Start on Node #{Chef.run_context.node.name}"
    opts[:message]     ||= '...'

    message = <<-MESSAGE
      From: #{opts[:from_alias]} <#{opts[:from]}>
      To: <#{to}>
      Subject: #{opts[:subject]}

      #{opts[:message]}
    MESSAGE

    mailtext = unindent message

    smtp = Net::SMTP.new(opts[:server], opts[:port])
    smtp.enable_starttls_auto
    smtp.start(opts[:server], opts[:from], opts[:password], :login)
    smtp.send_message(mailtext, opts[:from], to)
    smtp.finish

  end

end

module Tomcat
  require 'mechanize'

  # Function to know if tomcat is Running
  def self.is_running?
    tomcat = powershell_out!("(Get-Service Tomcat7).Status -eq \'Running\'")

    if tomcat.stdout[/True/]
      return true
    else
      return false
    end
  end

  # Method to pause execution while tomcat start
  def self.wait_start
    if is_running?
      agent = Mechanize.new
      agent.user_agent_alias = 'Windows Chrome'
      tries = 6

    	begin
      	agent.read_timeout = 5 #set the agent time out
      	page = agent.get('http://localhost:8080')
      	agent.history.pop   #delete this request in the history
        Chef::Log.info 'Tomcat7 Started'
    	rescue
        if (tries -= 1).zero?
          Tools.simple_email(
            'cbeleno@redsis.com',
            :message => 'Tomcat takes more than 15 minutes trying to restart, it is recommended to manually restart it.',
            :subject => "Node #{Chef.run_context.node.name} Need Help"
          )
        end

    		Chef::Log.info('Waiting 2.5 minutes for Tomcat7 to continue...')
    		agent.shutdown
    		agent = Mechanize.new { |agent| agent.user_agent_alias = 'Windows Chrome'}
    		agent.request_headers
    		sleep(150)

    		retry
    	end
    end
  end

end

module Java

  def self.get_exe

    if File.exist?('C:\Program Files\Java\jre7\bin\java.exe')

      return 'C:\Program Files\Java\jre7\bin\java.exe'

    elsif File.exist?('C:\Program Files\Java\jdk1.7.0_79\bin\java.exe')

      return 'C:\Program Files\Java\jdk1.7.0_79\bin\java.exe'

    elsif File.exist?('C:\Program Files (x86)\Java\jdk1.7.0_79\bin\java.exe')

      return 'C:\Program Files (x86)\Java\jdk1.7.0_79\bin\java.exe'

    else

      return 'C:\Program Files (x86)\Java\jre7\bin\java.exe'

    end

  end

end

Chef::Recipe.send(:include, Tools)
Chef::Recipe.send(:include, Tomcat)
Chef::Recipe.send(:include, Java)
