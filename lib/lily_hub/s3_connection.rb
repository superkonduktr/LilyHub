class LilyHub::S3Connection
  def initialize(directory_key = 'engravings')
    @@connection = Fog::Storage.new({
      provider: 'AWS',
      aws_access_key_id: ENV['LH_AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['LH_AWS_SECRET_ACCESS_KEY'],
      region: ENV['LH_AWS_REGION']
    })
    @bucket = @@connection.directories.get(directory_key) ||
              @@connection.directories.create(key: directory_key, public: true)
  end

  def upload_engraving(id, path)
    new_engraving = @bucket.files.create(
      key: "#{id}.png",
      body: File.open(path),
      public: true
    )
  end

  def get_url(id)
    @bucket.files.get("#{id.png}").public_url
  end
end
