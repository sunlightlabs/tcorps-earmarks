SCRIBD_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/scribd.yml")

Scribd::API.instance.key    = SCRIBD_CONFIG['scribd']['api_key']
Scribd::API.instance.secret = SCRIBD_CONFIG['scribd']['api_secret']
Scribd::API.instance.debug  = false