require 'open3'
require 'tmpdir'

class LilyHub::LilyCmd
  def initialize(text)
    @text = text
    @stderr, @status = nil
    @tmp_path = Dir.mktmpdir
    run
  end

  def run
    cmd = "lilypond --png -dpreview -o #{@tmp_path}/out -"
    Open3.popen3(cmd) do |i, o, e, t|
      i.write @text
      i.close
      @stderr = e.read
      @status = t.value
    end
  end

  def error?
    @status.to_i != 0
  end

  def errors
    @errors ||=
      @stderr.each_line
      .select { |l| l =~ /error:/i && l !~ /fatal error/i }
      .map do |l|
      line, msg = /^.?:(\d+):\d+:\serror:\s(.*)$/.match(l).captures
      { line: line, msg: msg }
    end
  end

  def result
    File.new("#{@tmp_path}/out.preview.png")
  end

  def clear
    FileUtils.rm_r @tmp_path
  end

end
