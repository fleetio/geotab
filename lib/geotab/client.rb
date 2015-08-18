module Geotab
  class Client
    AUTHENTICATION_URL = "https://my.geotab.com/apiv1/Authenticate"

    def authenticate(username, password, database=nil)
      response = Faraday.get(AUTHENTICATION_URL,
                             {userName: username, password: password, database: database})
      attributes = JSON.parse(response.body)

      @path = attributes["result"]["path"]
      set_credentials(attributes["result"]["credentials"].merge("path" => @path))
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
  end
end