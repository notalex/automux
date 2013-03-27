Automux::Cache.module_constants.each do |constant_name|
  Automux::Cache.const_get(constant_name).setup
end
