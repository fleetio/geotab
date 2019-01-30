module Geotab
  class Client
    DEFAULT_PATH = "my.geotab.com"

    # Authenticates with the Geotab API.
    def authenticate(username, password, database=nil, custom_path)
      @custom_path = custom_path

      authenticate_params = {
        method: "Authenticate",
        params: { userName: username, password: password, database: database }
      }
      response = Net::HTTP.post(URI(authentication_url),
                                authenticate_params.to_json,
                                "Content-Type" => "application/json", "Accept" => "application/json")

      result = JSON.parse(response.body)

      if result.has_key?("error")
        if result["error"]["code"] == -32000
          raise IncorrectCredentialsError, result["error"]["errors"].first["message"]
        else
          # Geotab API returned an error but used an unknown error code
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
      {
        database: @credentials['database'],
        userName: @credentials['userName'],
        sessionId: @credentials['sessionId']
      }
    end

    def path
      @path
    end

    def authentication_url
      "https://#{initial_path}/apiv1/"
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
