Rails.application.routes.draw do
  root 'static_pages#home'
  get 'about' => 'static_pages#about', as: :about
  get 'contact' => 'static_pages#contact', as: :contact
  get '*anything' => 'errors#routing_error'
end
