require 'refinery/generators'

class RefinerycmsTranslationsGenerator < ::Refinery::Generators::EngineInstaller

  source_root File.expand_path('../../../', __FILE__)
  engine_name 'refinerycms-translations'

end