Rails.application.routes.draw do
  resources :stages

  resources :ite_stage_results

  resources :race_runners

  resources :races

  resources :cyclists

  resources :ig_race_results

  resources :ig_stage_results

  resources :ite_stage_results

  resources :mountain_stage_results

  resources :stat_countries

  resources :stat_miscs

  resources :stat_stage_diffs

  resources :teams

  root :to => "races#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
