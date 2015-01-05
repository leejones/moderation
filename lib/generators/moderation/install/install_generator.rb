module Moderation
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      desc <<DESC
description :
    copy moderation configuration to an initializer.
DESC
      def create_configuration
        template 'moderation.rb', 'config/initializers/moderation.rb'
      end
    end
  end
end
