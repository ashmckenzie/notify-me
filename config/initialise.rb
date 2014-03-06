require 'hashie'
require 'stethoscope'

Stethoscope.url = "/"

ROOT_PATH = File.expand_path(File.join('..', '..'), __FILE__)
CONFIG_PATH = File.join(ROOT_PATH, 'config')
BASE_LIB_PATH = File.join(ROOT_PATH, 'lib')

$LOAD_PATH.unshift(BASE_LIB_PATH)

initialisers_path = File.join(CONFIG_PATH, 'initialisers', '**', '*.rb')
heartbeat_checks_path = File.join(CONFIG_PATH, 'heartbeat', '**', '*.rb')
lib_path = File.join(BASE_LIB_PATH, 'notify_me', '**', '*.rb')

LIBRARIES = Dir[lib_path]
LIBRARIES.sort.each { |file| require file }
Dir[initialisers_path].sort.each { |file| require file }
Dir[heartbeat_checks_path].sort.each { |file| require file }
