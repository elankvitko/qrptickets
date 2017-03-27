Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root :to => 'dashboard#index'

  resources :contact, :ticket
  resources :users


  get "mailbox/inbox" => "mailbox#inbox", as: :mailbox_inbox
  get "mailbox/sent" => "mailbox#sent", as: :mailbox_sent
  get "mailbox/trash" => "mailbox#trash", as: :mailbox_trash


  # conversations
  resources :conversations do
    member do
      post :reply
      post :trash
      post :untrash
    end
  end
end
