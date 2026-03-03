ArolitecSms.configure do |config|
    config.api_base_url = "https://apis.letexto.com/v1/messages/send"
    config.send_sms_endpoint = "https://apis.letexto.com/v1/messages/send"
    config.api_key = ENV["AROLITEC_SMS_API_KEY"]
    config.dlr_url = ""

end


