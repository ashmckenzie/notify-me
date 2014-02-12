ROOT_PATH = File.expand_path(File.join('..', '..'), __FILE__)
CONFIG_PATH = File.join(ROOT_PATH, 'config')
BASE_LIB_PATH = File.join(ROOT_PATH, 'lib')

$LOAD_PATH.unshift(BASE_LIB_PATH)

initialisers_path = File.join(CONFIG_PATH, 'initialisers', '**', '*.rb')
lib_path = File.join(BASE_LIB_PATH, 'notify_me', '**', '*.rb')

LIBRARIES = Dir[lib_path]
LIBRARIES.sort.each do |file|
  require file
end

Dir[initialisers_path].sort.each do |file|
  require file
end
