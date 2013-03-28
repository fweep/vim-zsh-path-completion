require 'spec_helper'

describe "s:index_of_first_mismatch" do

  let!(:sid) { VIM.command("echo g:zsh_path_completion_SID") }

  def index_of_first_mismatch(list)
    VIM.command("echo #{sid}index_of_first_mismatch(#{list})")
  end

  it "returns 0 when first characters differ" do
    list = build_list(%w{this foo llamatron})
    index_of_first_mismatch(list).should == "0"
  end


  it "returns 1 when second characters differ" do
    list = build_list(%w{cow crew clobber})
    index_of_first_mismatch(list).should == "1"
  end

  it "returns strlen when no mismatch" do
    word = "llama"
    list = build_list([word] * 2)
    index_of_first_mismatch(list).should == "#{word.length}"
  end
end
