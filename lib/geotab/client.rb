module Geotab
  class Client
    DEFAULT_PATH = "my.geotab.com"

    # Authenticates with the Geotab API.
    #
    # RestClient encodes special characters in the URL it sends to Geotab.
    # For example, https://my.geotab.com/apiv1/Authenticate?userName=test%40gmail.com&password=123%2C%2F%5Eabc&database=fleetio
    #
    # For some reason, Geotab's API can decode special characters in some cases,
    # but not in others. Since the password field is entirely user-created, and
    # since having special characters in your password is a best practice, this
    # presents a problem. Geotab has been unable to pinpoint why it sometimes
    # works and sometimes fails, so we enclose the entire password params in
    # quotes as a hack that seems to fix it. Unfortunately, this means that if
    # someone ever uses quotes in their password, it won't work. So, we do a 2nd
    # authentication request, this time encoding special characters in the
    # password, rather than enclosing the password in quotes, and in so doing,
    # we cover all possible password scenarios.
    def authenticate(username, password, database=nil, custom_path)
      @custom_path = custom_path

      response = RestClient::Request.execute({
        url: authentication_url,
        method: :get,
        verify_ssl: false,
        headers: { params: { userName: username, password: "'#{password}'", database: database }.to_json, content_type: :json, accept: :json }
      })
      result = JSON.parse(response.body)

      if result.has_key?("error")
        # 1st incorrect password - they might have a quote in their password,
        # so retry password with encoding rather than enclosing in quotes
        if result["error"]["code"] == -32000
          response = RestClient::Request.execute({
            url: authentication_url,
            method: :get,
            verify_ssl: false,
            headers: { params: { userName: username, password: password, database: database }.to_json, content_type: :json, accept: :json }
          })

          result = JSON.parse(response.body)

          # 2nd incorrect password, now we know their password is wrong for sure
          if result.has_key?("error")
            raise IncorrectCredentialsError, result["error"]["errors"].first["message"]
          end
        # Geotab API returned an error but used an unknown error code
        else
          raise ApiError, result["error"]["errors"].first["message"]
        end
      end

      set_path(result["result"]["path"])
      set_credentials(result["result"]["credentials"].merge("path" => @path))
    end

    def set_credentials(credentials)
      @credentials = credentials
      @path = credentials["path"]
      @credentials
    end

    def credentials
      "{'database':'#{@credentials['database']}','userName':'#{@credentials['userName']}','sessionId':'#{@credentials['sessionId']}'}"
    end

    def path
      @path
    end

    def authentication_url
      "https://#{initial_path}/apiv1/Authenticate"
    end

    def initial_path
      @custom_path || DEFAULT_PATH
    end

    def set_path path
      if path == "ThisServer"
        @path = initial_path
      else
        @path = path
      end
    end
  end
end
