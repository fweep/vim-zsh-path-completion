require 'spec_helper'

describe "s:all_string_indexes_match" do

  let!(:snr) { VIM.command("echo g:zsh_path_completion_SNR") }

  def all_string_indexes_match(list, index)
    VIM.command("echo #{snr}all_string_indexes_match(#{list}, #{index})")
  end

  def build_list(array)
    "[" + array.map {|a| "'#{a}'"}.join(', ') + "]"
  end

  it "when first characters match" do
    list = build_list(%w{then top truck})
    all_string_indexes_match(list, 0).should == "1"
  end

  it "when second characters match" do
    list = build_list(%w{xhis that those})
    all_string_indexes_match(list, 1).should == "1"
  end

  it "when first characters do not match" do
    list = build_list(%w{then top cow})
    all_string_indexes_match(list, 0).should == "0"
  end

end
