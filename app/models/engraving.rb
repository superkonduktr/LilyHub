class Engraving < ActiveRecord::Base

  validates :text, presence: { message: "of engraving can not be empty." }

  after_initialize do
    self.id ||= SecureRandom.uuid
    self.text ||= %{\\version \"2.18.2\"

\\header {
  title = "MY AWESOME SONG"
  composer = "Me"
}

\\score {
  \\new Staff {
    % make some noise
  }
}
}
  end

  before_create { self.text.strip! }

  scope :latest, -> { where(state: 'completed', is_private: false).order(created_at: :desc) }

  def error
    ''
  end

  def author
    'anonymous'
  end

  def url
    if state == 'completed'
      if Rails.env.development?
        "engravings/#{id}.png"
      elsif Rails.env.production?
        "https://engravings.s3-eu-central-1.amazonaws.com/#{id}.png"
      end
    else
      nil
    end
  end
end
