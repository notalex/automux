module Automux
  module Controller
    class Base
      include Support::Rendering
      extend Support::Filters

      attr_reader :params

      def initialize(params = {})
        @params = params
      end

      def notify_error(message)
        Automux::Controller::Messages.new(message: message).error
      end

      def check_blueprint
        notify_error "Unable to find blueprint named #{ params[:blueprint_name] }.yml" if @blueprint.nil?
      end
    end
  end
end
