class ControllerUtil

  def self.clean_params(params, expected_keys)
    filtered_params = {}
    expected_keys.each do |key|
      filtered_params[key] = params[key]
    end
    filtered_params
  end

end
