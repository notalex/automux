require 'erb'

module Automux
  module Library
    class MiniErb < ERB

      def initialize(template)
        modified_template = erb_parseable_template(template)
        super(modified_template, nil, '%<>')
      end

      private ###

      # - [1, 2, 3]      =>     % [1, 2, 3]
      # = [1, 2, 3]      =>     <%= [1, 2, 3] %>
      def erb_parseable_template(string)
        string.gsub(/^\s*-(.+)$/, '%\1')
              .gsub(/^\s*=(.+)$/, '<%=\1 %> ')
      end
    end
  end
end
