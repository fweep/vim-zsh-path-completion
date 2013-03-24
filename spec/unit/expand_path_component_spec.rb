require 'spec_helper'

describe "s:expand_path_component" do

  let!(:sid) { VIM.command("echo g:zsh_path_completion_SID") }

  before do
    FileUtils.mkdir_p "foo/bar/b/blah"
    FileUtils.mkdir_p "foo/bar/baz/blah"
    FileUtils.mkdir_p "foo/bar/bzz/goat"
  end

  after do
    FileUtils.rm_rf "foo"
  end

  def expand_path_component(path_component)
    VIM.command("echo #{sid}expand_path_component('#{path_component}')")
  end

  it "expands unambiguous top-level directory" do
    expand_path_component("f").should == build_list(%w{foo})
  end

  it "expands unambiguous nested directory" do
    expand_path_component("foo/b").should == build_list(%w{foo/bar})
  end

  it "expands ambiguous nested directories" do
    dirs = %w{foo/bar/b foo/bar/baz foo/bar/bzz}
    expand_path_component("foo/bar/b").should == build_list(dirs)
  end

  it "descends with trailing /" do
    expand_path_component("foo/").should == build_list(%w{foo/bar})
  end

  it "does not descend on full match" do
    expand_path_component("foo").should == build_list(%w{foo})
  end
end
