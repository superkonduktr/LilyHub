require 'lilyhub'

class EngravingWorker

  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(engraving_id)
    engraving = Engraving.find(engraving_id)

    cmd = LilyHub::LilyCmd.new(engraving.text)

    begin
      if cmd.error?
        Rails.logger.warn("Errors: #{cmd.errors.inspect}")
        engraving.update(state: 'error', error: cmd.errors.to_json)
      else
        Rails.logger.info("All good, no errors")
        if Rails.env.development?
          FileUtils.cp cmd.result.path,
                       Rails.root + "public/images/engravings/#{engraving.id}.png"
        elsif Rails.env.production?
          LilyHub.s3.upload_engraving(engraving_id, cmd.result.path)
        end
        engraving.update(state: "completed")
      end
    ensure
      cmd.clear
    end
  end
end
