# lib/capistrano/tasks/sidekiq.rake
namespace :sidekiq do
  desc "Redémarrer le service Sidekiq de Yeta+"
  task :restart do
    on roles(:app) do
      # Redémarrage du service systemd spécifique
      #execute :sudo, :systemctl, "restart renouveaugroupe-test.sidekiq"
      execute :sudo, :systemctl, "restart prod.yetaplus.sidekiq"
    end
  end
end

# Hook pour redémarrer Sidekiq après la publication de la release
after 'deploy:publishing', 'sidekiq:restart'
