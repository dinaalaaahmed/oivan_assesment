Rails.application.routes.draw do
  resource :urls

  get 'decode', to: "urls#decode"
  post 'encode', to: "urls#encode"
end
