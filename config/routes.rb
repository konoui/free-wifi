Rails.application.routes.draw do
  namespace :api, { format: 'json' } do
    namespace :v1 do
       get 'spots/json'
    end
  end
end
