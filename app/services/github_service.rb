class GithubService
  BASE_URL = 'https://api.github.com'
  STAR_RANGE = '1..2000'
  LICENSE = %w[apache-2.0 gpl lgpl mit]
  LANGUAGES = ['Ruby', 'Javascript']

  def get_projects
    response = client.get do |request|
      request.url('/search/repositories')
      request.params['q'] = search_params
    end

    JSON.parse(response.body)
  end

  private def search_params
    # fork:false is default
    # pluses to separate the params aren't working right,
    # but spaces seem to be converting to + so let's run with it.
    "#{language_params} #{star_params} #{updated_at_params} #{license_params}"
  end

  private def language_params
    'language:' + LANGUAGES.join(' language:')
  end

  private def star_params
    "stars:#{STAR_RANGE}"
  end

  private def updated_at_params
    "pushed:>#{Date.yesterday.to_s}"
  end

  private def license_params
    'license:' + LICENSE.join(' license:')
  end

  private def client
    @_client ||= Faraday.new(url: BASE_URL) do |faraday|
      faraday.adapter Faraday.default_adapter
      faraday.options.params_encoder = Faraday::FlatParamsEncoder
    end
  end
end
