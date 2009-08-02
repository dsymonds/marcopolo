#! /usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), 'ext')

require 'cgi'  # needed by Plist module
require 'plist'

SENSOR_DIR = "Sensors"

RED_ON = "\033[0;31;1m"
COLOUR_OFF = "\033[0m"

# Global Stats
$lint_errors = 0

class Linter
  def initialize(sensor)
    @sensor = sensor
    @sensor_dir = File.join(SENSOR_DIR, @sensor)
  end

  def lintError(message)
    $stderr.puts "[#{@sensor}] #{message}"
    $lint_errors += 1
  end

  def assert(condition, message)
    lintError(message) if not condition
  end

  def assertEquals(var, expected, actual)
    assert(expected == actual, "Expected #{var} == #{expected}, got #{actual}")
  end

  def lint
    # First, check for required files
    ["#{@sensor}-Info.plist", "#{@sensor}.m", "#{@sensor}.h"].each do |file|
      path = File.join(@sensor_dir, file)
      assert(File.exists?(path), "#{path} doesn't exist")
    end

    ######################
    # check the plist file
    plist_filename = File.join(@sensor_dir, "#{@sensor}-Info.plist")
    plist = Plist::parse_xml(plist_filename)
    assert(plist, "#{plist_filename} is not a valid plist")
    assertEquals('CFBundleDevelopmentRegion', 'en',
                 plist['CFBundleDevelopmentRegion'])
    assertEquals('CFBundleIdentifier', "au.id.symonds.MarcoPolo.#{@sensor}",
                 plist['CFBundleIdentifier'])
    assertEquals('NSPrincipalClass', @sensor, plist['NSPrincipalClass'])
  end
end

if $0 == __FILE__
  if not File.directory? "Sensors"
    $stderr.puts "Please run this from the MarcoPolo root dir!"
    exit 1
  end

  Dir[File.join(SENSOR_DIR, "*")].map { |f| File.basename(f) }.each do |sensor|
    $stderr.puts "==> Linting #{sensor}..."
    linter = Linter.new(sensor)
    linter.lint
  end

  if $lint_errors > 0
    $stderr.puts "==> #{RED_ON}Found #{$lint_errors} " +
                 "error#{"s" if $lint_errors > 1}#{COLOUR_OFF}"
  else
    $stderr.puts "==> All okay"
  end
end
