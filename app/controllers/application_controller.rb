class ApplicationController < ActionController::Base
  protect_from_forgery
  force_ssl
  http_basic_authenticate_with name: "Ottmar.Schoch@donbosco.de",  password: "DonBosco1815"
    
  def log(art,str)
    log = open(Rails.root.join('log','my.log'),'a')
    log.write "#{Time.new.strftime("%d.%m.%y %H:%M:%S")} #{art}: #{controller_name} #{action_name} #{str}\n"
    log.close
  end
  
end
