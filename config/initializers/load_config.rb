# Thanks to Ryan Bates for sharing this configuration file tip:
# http://railscasts.com/episodes/85-yaml-configuration-file
APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")[RAILS_ENV]
