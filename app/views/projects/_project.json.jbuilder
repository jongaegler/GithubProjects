json.extract! project, :id, :name, :user_id, :github_url, :stars, :created_at, :updated_at
json.url project_url(project, format: :json)
