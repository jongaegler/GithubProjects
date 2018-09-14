json.extract! project, :id, :name, :user_name, :github_url, :stars, :created_at, :updated_at
json.url project_url(project, format: :json)
