module VimHelpers

  def build_list(array)
    "[" + array.map {|a| "'#{a}'"}.join(', ') + "]"
  end

end
