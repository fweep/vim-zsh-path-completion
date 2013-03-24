require 'spec_helper'

describe "s:longest_common_string_prefix" do

  let!(:sid) { VIM.command("echo g:zsh_path_completion_SID") }

  def longest_common_string_prefix(list)
    VIM.command("echo #{sid}longest_common_string_prefix(#{list})")
  end

  it "is blank when none match" do
    longest_common_string_prefix(%w{foo bar llama}).should == ''
  end

  it "is blank when first two of three match" do
    longest_common_string_prefix(%w{foo food baz}).should == ''
  end

  it "matches single character" do
    longest_common_string_prefix(%w{fee fie foe}).should == 'f'
  end

  it "matches multiple characters with no complete match" do
    longest_common_string_prefix(%w{fees feed feet}).should == 'fee'
  end

  it "matches multiple characters with one complete match" do
    longest_common_string_prefix(%w{bees bee beet}).should == 'bee'
  end

  it "matches multiple characters with all exact matches" do
    longest_common_string_prefix(%w{cow cow cow}).should == 'cow'
  end

end
