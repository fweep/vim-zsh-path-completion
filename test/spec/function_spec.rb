# NOTE: Tests require Vim with X11 and +clientserver.

require 'spec_helper'

describe "vim-zsh-path-completion" do

  let!(:snr) { VIM.command("echo g:zsh_path_completion_SNR") }

  it "meets requirements" do
    VIM.command("echo &cp").should == "0"
    VIM.command("echo v:version").to_i.should >= 700
  end

  it "sets a flag on load" do
    VIM.command("echo g:loaded_zsh_path_completion").should == "1"
  end

  describe "s:expand_path_component" do

    before do
      FileUtils.mkdir_p "foo/bar/b/blah"
      FileUtils.mkdir_p "foo/bar/baz/blah"
      FileUtils.mkdir_p "foo/bar/bzz/goat"
    end

    after do
      FileUtils.rm_rf "foo"
    end

    def expand_path_component(path_component)
      VIM.command("echo #{snr}expand_path_component('#{path_component}')")
    end

    it "expands unambiguous top-level directory" do
      expand_path_component("f").should == path_list("foo")
    end

    it "expands unambiguous nested directory" do
      expand_path_component("foo/b").should == path_list("foo/bar")
    end

    it "expands ambiguous nested directories" do
      dirs = %w{foo/bar/b foo/bar/baz foo/bar/bzz}
      expand_path_component("foo/bar/b").should == path_list(*dirs)
    end

    it "descends with trailing /" do
      expand_path_component("foo/").should == path_list("foo/bar")
    end

    it "does not descend on full match" do
      expand_path_component("foo").should == path_list("foo")
    end
  end

private

  def path_list(*args)
    "[" + args.map {|a| "'#{a}'"}.join(', ') + "]"
  end

end
