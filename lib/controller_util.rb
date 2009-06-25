class ControllerUtil

  def self.clean_params(params, expected_keys)
    Rails.logger.info "== ControllerUtil.clean_params : params : " + params.to_yaml
    filtered_params = {}
    expected_keys.each do |key|
      filtered_params[key] = params[key]
    end
    filtered_params
  end

end
