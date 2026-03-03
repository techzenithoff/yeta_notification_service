require "uri"
require_relative "exceptions"

module ArolitecSms
    class Client

        def send(sender, receiver, content)
           

            message = {}
            
            message[:sender] = sender
            message[:receiver] = receiver
            message[:content] = content

            send_sms(message)
           

        end




        private

            
            


            def send_sms(message)
                 
                
                 
                payload = "?from=#{CGI.escape(message[:sender])}&to=#{CGI.escape(message[:receiver])}&content=#{CGI.escape(message[:content])}&token=#{ArolitecSms.configuration.api_key}"
                

                #puts "LE PAYLOAD: #{CGI.escape(payload)}"
                puts "LE PAYLOAD: #{URI::Parser.new.escape(payload)}"

                 # Inialize a new connection.
                request = Faraday.new(ArolitecSms.configuration.api_base_url, 
                    ssl: {
                    ca_path: "/usr/lib/ssl/certs"}
                )

                # Making a http post request
                response =  request.get do |req|
                    req.url  ArolitecSms.configuration.api_base_url + payload                  
                    # Request header
                    req.headers['Authorization'] = "Bearer #{ArolitecSms.configuration.api_key}"
                    req.headers['Content-Type'] = 'application/json'
                    req.headers['Accept'] = 'application/json'
                    
                    # Request body
                    #req.body = payload#.to_json
                end

            

                if response.status == 200
                    puts "LA REPONSE DE LA REQUETTE EST: #{response.body}"

                    return response
                    
                elsif response.status == 401
                    puts "LA REPONSE DE LA REQUETTE EST: #{response.body}"
                    return response

                end
                
            
            end

    end
end