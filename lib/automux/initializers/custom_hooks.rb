Automux::Controller.base_inheriting_classes.each do |class_name|
  Automux::Controller::Base.after_inherited(Automux::Controller.const_get(class_name))
end
