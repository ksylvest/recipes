# frozen_string_literal: true

require "bundler"

Bundler.require
Dotenv.load

ROOT = Pathname.new(__dir__).parent

loader = Zeitwerk::Loader.new
loader.push_dir("#{ROOT}/app")
loader.push_dir("#{ROOT}/app/tools")
loader.setup

Dir.glob("#{ROOT}/config/initializers/**/*.rb").each { |file| require file }
