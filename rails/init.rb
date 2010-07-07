Refinery::Plugin.register do |plugin|
  plugin.title = "Translations"
  plugin.name = "translations"
  plugin.description = "Manage Translations"
  plugin.version = 1.0
  plugin.activity = {
    :class => Translation,
    :url_prefix => "edit",
    :title => 'name'
  }
  # this tells refinery where this plugin is located on the filesystem and helps with urls.
  plugin.directory = directory
end
