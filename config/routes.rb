Rails.application.routes.draw do
  
  get 'sessions/create'
  get 'sessions/destroy'

  get 'question_answer/index' => 'question_answer#index', as: :ques_answer
  get 'question_answer/show' => 'question_answer#show', as: :ques_show
  get 'question_answer/update' => 'question_answer#update', as: :ques_update
  get 'question_answer/delete'
  get 'question_answer/show_question' => 'question_answer#show_question', as: :show_question
  get 'question_answer/booty', as: :booty

  get 'question_answer/create'
  post 'question_answer/create' => "question_answer#create", as: :qcreate
  

  get 'chapters/show' => 'chapters#show', as: :chaptershow
  get 'chapters/new' => 'chapters#new', as: :chapternew
  get 'chapters/create' => 'chapters#create', as: :chaptercreate
  post 'chapters/:id/edit' => 'chapters#edit', as: :chaptereditpost
  patch 'chapters/:id/edit' => 'chapters#edit', as: :chapterpatch
  get '/chapters/:id', to: 'chapters#update', as: :chapterupdate
  get 'chapters/destroy' => 'chapters#destroy', as: :chapterdestroy
  get 'chapters/index' => 'chapters#index', as: :chapterindex
  post 'chapters/create'
  resources :chapters


  get 'glossaries/index' => 'glossaries#index', as: :glossary
  get 'glossaries/show' => 'glossaries#show', as: :glossaryshow
  get 'glossaries/new' => 'glossaries#new', as: :glossarynew
  get 'glossaries/create' => 'glossaries#create', as: :glossarycreate
  get 'glossaries/delete' => 'glossaries#delete', as: :glossarydelete
  post 'glossaries/:id/edit' => 'glossaries#edit', as: :glossarypost
  patch 'glossaries/:id/edit' => 'glossaries#edit', as: :glossarypatch
  get 'glossaries/destroy' => 'glossaries#destroy', as: :glossarydestroy

  post 'glossaries/create'
  get 'glossaries/:id', to: 'glossaries#update', as: :glossaryupdate

  resources :glossaries

  get 'organizers/index' => "organizers#index", as: :adminindex
  get 'organizers/new' => "organizers#new", as: :adminnew
  get 'organizers/profile' => 'organizers#profile', as: :profile
  get 'organizers/admin_logout' => 'organizers#admin_logout', as: :admin_logout 
  get 'organizers/create'
  post 'organizers/create'
  get 'organizers/destroy' => "organizers#destroy", as: :admindestroy
  get 'organizers/login'
  get 'admin' => 'organizers#login', as: :adminlogin
  post 'organizers/login'
  get 'organizers/admin' => "organizers#admin", as: :admin
  post 'organizers/admin'
  get '/organizers/:id', to: 'organizers#update', as: :organizerupdate
  post 'organizers/:id/edit' => 'organizers#edit', as: :organizerpost
  patch 'organizers/:id/edit' => 'organizers#edit', as: :organizerpatch
  resources :organizers

  get 'media/index' => "media#index", as: :mediaindex
  get 'media/new' => "media#new", as: :medianew
  get 'media/create' => "media#create", as: :mediacreate
  get 'media/show' => "media#show", as: :mediashow
  get '/media/:id', to: 'media#update', as: :mediaupdate
  post 'media/:id/edit' => 'media#edit', as: :mediaeditpost
  patch 'media/:id/edit' => 'media#edit', as: :mediapatch
  get 'media/destroy' => "media#destroy", as: :mediadestroy
  post 'media/create'
  resources :media

  
  get 'lessons/index' => "lessons#index", as: :lessonindex
  post 'lessons/index' => "lessons#index", as: :lessonindex1
  get 'lessons/new' => "lessons#new", as: :newlesson
  get 'lessons/create' => "lessons#create", as: :createlesson
  get 'lessons/destroy' => "lessons#destroy", as: :destroy
  get 'lessons/chapter' => "lessons#chapter", as: :chapter1
  get 'lessons/show' => "lessons#show", as: :lessonshow
  get 'lessons/show_lesson' => 'lessons#show_lesson', as: :l_show_lesson
  get 'lessons/show_chapter_lessons' => 'lessons#show_chapter_lessons', as: :show_chapter_lessons
  get 'lessons/show_chapter' => 'lessons#show_chapter', as: :show_chapter
  get 'lessons/new_instruction' => 'lessons#new_instruction', as: :new_instruction
  get 'lessons/create_instruction' => 'lessons#create_instruction', as: :create_instruction
  post 'lessons/create_instruction'

  post 'lessons/:id/edit' => 'lessons#edit', as: :lessoneditpost
  patch 'lessons/:id/edit' => 'lessons#edit', as: :lessonpatch
  get 'lessons/:id', to: 'lessons#update', as: :lessonupdate
  post 'lessons/create'
  resources :lessons
  

  root 'students#index', as: :index
  get 'students/new' => "students#new", as: :new
  post 'students/create'
  get 'students/update' => "students#update", as: :update
  get 'students/delete'
  get 'students/signin' => "students#signin", as: :signin
  get 'students/show' => "students#show", as: :show
  post 'students/create_sign'
  get 'students/show_lesson' => 'lessons#show_lesson', as: :show_lesson  
  get 'students/badge' => 'students#badge', as: :badge
  get 'students/edit' => 'students#edit', as: :studenteditget
  post 'students/:id/edit' => 'students#edit', as: :studentseditpost
  patch 'students/:id/edit' => 'students#edit', as: :studentspatch
  get '/students/:id', to: 'students#update', as: :studentsupdate
  resources :students

  get 'logout2' => "lessons#logout", as: :logout
  
  get '/auth/:provider/callback', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  resources :sessions, only: [:create, :destroy]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
