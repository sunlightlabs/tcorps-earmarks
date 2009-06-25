API_SETUP = YAML.load_file("#{RAILS_ROOT}/config/api_setup.yml")

require 'rscribd'
Scribd::API.instance.key    = API_SETUP['scribd']['api_key']
Scribd::API.instance.secret = API_SETUP['scribd']['api_secret']
Scribd::API.instance.debug  = false
