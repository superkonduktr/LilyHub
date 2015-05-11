module LilyHub
  def self.s3
    @s3 ||= LilyHub::S3Connection.new
  end
end
