require 'spec_helper'

describe "s:shortest_string_in_list" do

  let!(:snr) { VIM.command("echo g:zsh_path_completion_SNR") }

  def shortest_string_in_list(list)
    VIM.command("echo #{snr}shortest_string_in_list(#{list})")
  end

  def build_list(array)
    "[" + array.map {|a| "'#{a}'"}.join(', ') + "]"
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
