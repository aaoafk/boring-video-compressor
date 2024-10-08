Rails.application.routes.draw do
  # TODO: Review routes. Ensure that dead routes are not drawn and ensure that this is idiomatic with rails.
  get "videos/compress"
  get "videos/download"
  get "pages/home"
  get "pages/about"
  get "pages/how_to_use"
  get "pages/built_by"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  post "compress_video", to: "videos#compress"
  get "download_video", to: "videos#download"
  root "pages#home"
end
