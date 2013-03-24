# NOTE: Tests require Vim with X11 and +clientserver.

require 'spec_helper'

describe "vim-zsh-path-completion" do

  it "meets requirements" do
    VIM.command("echo &cp").should == "0"
    VIM.command("echo v:version").to_i.should >= 700
  end

  it "sets a flag on load" do
    VIM.command("echo g:loaded_zsh_path_completion").should == "1"
  end

end
