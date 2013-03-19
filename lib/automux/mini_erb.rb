require 'erb'

module Automux
  module MiniErb
    class MiniErb < ERB

      def initialize(template)
        modified_template = erb_parseable_template(template)
        super(modified_template, nil, '%<>')
      end

    private

      def erb_parseable_template(string)
        string.gsub(/^\s*-(.+)$/, '%\1').
               gsub(/^\s*=(.+)$/, '<%=\1 %> ')
      end
    end
  end
end
