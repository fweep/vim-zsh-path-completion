# Acknowledgements:
#   This is almost verbatim from an article by Paul Mucur on testing Vim
#   plugins with RSpec, and another article by the author of Vimrunner,
#   Andrew Radev.  Thanks Andrew and Paul!
#   http://andrewradev.com/2011/11/15/driving-vim-with-ruby-and-cucumber/
#   http://mudge.name/2012/04/18/testing-vim-plugins-on-travis-ci-with-rspec-and-vimrunner.html

require 'vimrunner'
require 'tmpdir'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.order = 'random'

  config.before :suite do
    VIM = Vimrunner.start
    plugin_path = File.expand_path('../../..', __FILE__)
    VIM.add_plugin(plugin_path, 'plugin/zshpathcompletion.vim')
  end

  config.after :suite do
    VIM.kill
  end

  config.around do |example|
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        VIM.command("cd #{dir}")
        example.call
      end
    end
  end

end
