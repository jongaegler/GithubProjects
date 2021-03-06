class GithubService
  BASE_URL = 'https://api.github.com'
  LICENSE = %w[apache-2.0 gpl lgpl mit]
  LANGUAGES = ['Ruby', 'Javascript']

  def initialize
    @page = 1
    @max_stars = Project::STAR_MAX
  end

  def run
    projects = projects_request
    return if projects.blank?

    projects.each { |project| import_project(project) }

    update_variables

    run
  end

  private

  def projects_request
    response = client.get do |request|
      request.url('/search/repositories')

      request.params['q'] = search_params
      request.params['per_page'] = 100
      request.params['page'] = @page
      request.params['sort'] = 'stars'
      request.params['access_token'] = ENV['ACCESS_TOKEN']
    end

    handle_response(response)
  end

  def handle_response(response)
    JSON.parse(response.body)['items']
  end

  def update_variables
    if @page == 10 && @max_stars != 1
      @page = 1
      @max_stars = Project.last.stars
    else
      @page += 1
    end
  end

  def import_project(project_hash)
    Project.find_or_create_by(github_url: project_hash['html_url']) do |project|
      project.name = project_hash['name']
      project.stars = project_hash['stargazers_count']
      project.user_name = project_hash['owner']['login']
    end
  end

  def search_params
    # fork:false is default
    # '+' to separate the params aren't working right,
    # but spaces seem to be converting to + so let's run with it.
    "#{language_params} #{star_params} #{updated_at_params} #{license_params}"
  end

  def language_params
    'language:' + LANGUAGES.join(' language:')
  end

  def star_params
    "stars:#{(1..@max_stars)}"
  end

  def updated_at_params
    "pushed:>#{Date.yesterday}"
  end

  def license_params
    'license:' + LICENSE.join(' license:')
  end

  def client
    @client ||= Faraday.new(url: BASE_URL) do |faraday|
      faraday.adapter Faraday.default_adapter
      faraday.options.params_encoder = Faraday::FlatParamsEncoder
    end
  end
end
