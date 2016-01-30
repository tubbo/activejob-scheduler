Rails.application.routes.draw do

  mount ActivejobScheduler::Engine => "/activejob_scheduler"
end
