Rails.application.routes.draw do
  resources :races, :cyclists, :ig_race_results, :ig_stage_results, :ite_stage_results,:mountain_stage_results,:race_runners,:race_teams,:stages,:stat_ages,:stat_countries,:stat_miscs,:stat_stage_diffs,:teams,:yj_stage_results
  root :to => "races#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

