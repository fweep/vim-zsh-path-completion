describe "s:expand_path" do

  # FIXME: turn some of these into integration tests

  let!(:sid) { VIM.command("echo g:zsh_path_completion_SID") }

  def expand_path(path_components)
    VIM.command("echo #{sid}expand_path(#{path_components})")
  end

  describe "with an empty directory" do
    it "expands 's' to blank" do
      expand_path(["s"]).should == ""
    end
  end

  describe "with one file named 'stuff'" do
    before { FileUtils.touch("stuff") }
    it "expands 's'" do
      expand_path(["s"]).should == "stuff"
    end
    it "expands 'st'" do
      expand_path(["st"]).should == "stuff"
    end
    it "handles 'stuff'" do
      expand_path(["stuff"]).should == "stuff"
    end
  end

  describe "with a file extension" do
    before { FileUtils.touch("stuff.txt") }
    it "matches full filename" do
      expand_path(["st"]).should == "stuff.txt"
    end
  end

  describe "with a space in the filename" do
    before { FileUtils.touch("more stuff.txt") }
    it "matches full filename" do
      expand_path(["m"]).should == "more stuff.txt"
    end
  end

  describe "with two non-matching files" do
    let(:filenames) { ["stuff", "things"] }
    before { filenames.each {|f| FileUtils.touch(f) } }
    it "expands the first name" do
      expand_path(["st"]).should == "stuff"
    end
    it "expands the second name" do
      expand_path(["th"]).should == "things"
    end
  end

  describe "with two partially-matching files" do
    let(:filenames) { ["these", "those"] }
    before { filenames.each {|f| FileUtils.touch(f) } }
    it "expands the common prefix" do
      expand_path(["t"]).should == "th"
    end
  end

  describe "with one directory" do
    before { FileUtils.mkdir_p "mydir" }
    it "adds a trailing /" do
      expand_path(['m']).should == "mydir/"
    end

    describe "containing two similarly-named files" do
      let(:filenames) { ["golf", "goats"] }
      before { filenames.each {|f| FileUtils.touch("mydir/#{f}") } }
      it "expands the common prefix given a full directory name and partial filename" do
        path_components = build_list(%w{mydir g})
        expand_path(path_components).should == "mydir/go"
      end
      it "expands the common prefix given a partial directory name and partial filename" do
        path_components = build_list(%w{m g})
        expand_path(path_components).should == "mydir/go"
      end
    end

    describe "containing a subdirectory" do
      it "expands the subdirectory with a trailing /" do
        FileUtils.mkdir_p "mydir/subdir"
        path_components = build_list(%w{m s})
        expand_path(path_components).should == "mydir/subdir/"
      end
    end
  end

  describe "with two partially-matching directories" do
    let(:dirnames) { ["these", "those"] }
    before { dirnames.each {|d| FileUtils.mkdir_p(d) } }
    it "expands the common prefix with no trailing /" do
      expand_path(['t']).should == "th"
    end
    describe "with a file in one directory" do
      before { FileUtils.touch("these/foo") }
      it "expands only the common prefix with an ambiguous directory match" do
        path_components = build_list(%w{t f})
        expand_path(path_components).should == "th"
      end
    end
  end

  describe "with nested directories" do
    let(:top_dirnames) { ["src", "tmp"] }
    before { top_dirnames.each {|d| FileUtils.mkdir_p(d) } }
    describe "where the second partially matches" do
      let(:mid_dirnames) { ["pants", "parts"] }
      before { mid_dirnames.each {|d| FileUtils.mkdir_p("src/#{d}") } }
      it "expands the common prefix" do
        path_components = build_list(%w{s p})
        expand_path(path_components).should == "src/pa"
      end
      it "expands the common prefix with a file" do
        FileUtils.touch("src/pants/foo")
        path_components = build_list(%w{s p f})
        expand_path(path_components).should == "src/pa"
      end
    end
  end

end
