require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:development, :doc)
rescue Bundler::BundlerError => e
  STDERR.puts e.message
  STDERR.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'rake/clean'
require 'jeweler'

Jeweler::Tasks.new do |gemspec|
  gemspec.rubyforge_project = 'ffi-pcap'
  gemspec.name = "ffi-pcap"
  gemspec.summary = "FFI bindings for libpcap"
  gemspec.email = "postmodern.mod3@gmail.com"
  gemspec.homepage = "http://github.com/sophsec/ffi-pcap"
  gemspec.description = "Bindings to libpcap via FFI interface in Ruby."
  gemspec.authors = ["Postmodern", "Dakrone", "Eric Monti"]
  gemspec.requirements = ['libpcap or winpcap (if on Windows)']
  gemspec.has_rdoc = 'yard'
end

require 'spec/rake/spectask'

desc "Run all specifications"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.libs += ['lib', 'spec']
  t.spec_opts = ['--colour', '--format', 'specdoc']
end
task :default => :spec

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

require 'yard'
YARD::Rake::YardocTask.new
task :docs => :yard
