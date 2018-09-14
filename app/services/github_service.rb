class GithubService
  BASE_URL = 'https://api.github.com'
  STAR_RANGE = '1..2000'
  LICENSE = %w[apache-2.0 gpl lgpl mit]
  LANGUAGES = ['Ruby', 'Javascript']

  def initialize
    @page = 1
  end

  def run
    projects = get_projects(@page)
    return unless projects
    @page += 1
    projects.each { |project| import_project(project) }
    run
  end

  def get_projects(page)
    response = client.get do |request|
      request.url('/search/repositories')
      request.params['q'] = search_params
      request.params['page'] = page
      request.params['sort'] = created
    end

    JSON.parse(response.body)['items'] # 30 per page
  end

  def import_project(project_hash)
    Project.find_or_create_by(github_url: project_hash['url']) do |project|
      project.name = project_hash['name']
      project.stars = project_hash['stargazers_count']
      project.user_name = project_hash['owner']['login']
    end
  end

  def create_project
  end

  private def search_params
    # fork:false is default
    # '+' to separate the params aren't working right,
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
