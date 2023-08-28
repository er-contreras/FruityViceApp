Rails.application.routes.draw do
  root 'fruits#index'
  get 'fruits/export_csv', to: 'fruits#export_csv'
end
