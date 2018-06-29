Rails.application.routes.draw do
  resources :stage_locations
  resources :races
  resources :cyclists
  resources :ig_race_results
  resources :ig_stage_results
  resources :ite_stage_results
  resources :mountain_stage_results
  resources :race_runners
  resources :race_teams
  resources :stages
  resources :stat_ages
  resources :stat_countries
  resources :stat_miscs
  resources :stat_stage_diffs
  resources :teams
  resources :yj_stage_results
  root :to => "races#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

