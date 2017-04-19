module Request
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end

  module HeadersHelpers
    def api_header(version = 1)
      request.headers["Accept"] = "application/vnd.marketplace.v#{version}"
    end

    # Deprecation warning - Mime::JSON has been replace by Mime[:json]
    # https://github.com/rails/jbuilder/issues/345
    def api_response_format(format = Mime[:json])
      request.headers["Accept"] = "#{request.headers["Accept"]}, #{format}"
      request.headers["Content-Type"] = format.to_s
    end

    def include_default_accept_headers
      # Not calling api_header in order to remove application/vnd.marketplace.v1
      # from Accept header due to no corresponding renderer for this format.
      # api_header
      api_response_format
    end
  end
end
