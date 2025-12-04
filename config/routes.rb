Rails.application.routes.draw do
  resource :urls

  post "decode", to: "urls#decode"
  post "encode", to: "urls#encode"
end
