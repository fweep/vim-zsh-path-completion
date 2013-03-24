require 'spec_helper'

describe "s:shortest_string_in_list" do

  let!(:sid) { VIM.command("echo g:zsh_path_completion_SID") }

  def shortest_string_in_list(list)
    VIM.command("echo #{sid}shortest_string_in_list(#{list})")
  end

  it "finds the shortest when first" do
    list = build_list(%w{foo blammo something})
    shortest_string_in_list(list).should == "foo"
  end

  it "finds the shortest when last" do
    list = build_list(%w{blammo something foo})
    shortest_string_in_list(list).should == "foo"
  end

end
