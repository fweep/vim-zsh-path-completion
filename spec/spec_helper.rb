require 'rubygems'
require 'rspec'
require 'spork'

Spork.prefork do
  require 'vimrunner'
  require 'tmpdir'

  # FIXME: why isn't RSpec finding VimHelpers?
  require 'support/vim_helpers'

  RSpec.configure do |config|
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.order = 'random'

    config.include VimHelpers

    # FIXME: if any of the tests leave Vim in a weird state,
    #   spork will need to be restarted.  it'd be better to bounce
    #   it here, but mvim doesn't run headlessly and restarts suck.
    # config.before :suite do
      # FIXME: osx-only (and possibly darwinports-only) config right now.
      # VIM = Vimrunner.start
      VIM = Vimrunner::Server.new("/opt/local/bin/mvim").start
      plugin_path = File.expand_path('../..', __FILE__)
      VIM.add_plugin(plugin_path, 'plugin/zshpathcompletion.vim')
    # end

    # config.after :suite do
      # VIM.kill
    # end

    config.around do |example|
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          VIM.command("cd #{dir}")
          example.call
        end
      end
    end
  end
end

Spork.each_run do
end
