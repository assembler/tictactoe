Tictactoe::Application.routes.draw do
  resources :games
  resource  :stats

  root to: 'main#index'

end
