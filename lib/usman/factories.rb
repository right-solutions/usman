# This is to expose the factories in this gem
# By default, only files in /lib is exported
# hence this hack.
# Read More: https://stackoverflow.com/questions/31700345/how-can-i-share-the-factories-that-i-have-in-a-gem-and-use-it-in-other-project

GEM_USMAN_ROOT = File.dirname(File.dirname(File.dirname(__FILE__)))
Dir[File.join(GEM_USMAN_ROOT, 'spec', 'dummy', 'spec', 'factories', '**','*.rb')].each { |file| require(file) }
