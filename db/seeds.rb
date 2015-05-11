Engraving.destroy_all
# FileUtils.rm_r "app/assets/images/engravings"

# Sample engraving:
#
# sample_code = %/{
#   bes8 bes[( g]) g
# }
# \\addlyrics {
#   \\override LyricText.font-shape = #'italic
#   Spru- | u-u-u- | uce!
# }/

# sample_engraving = Engraving.new(text: sample_code, is_private: false, state: "new")

# if sample_engraving.save
#   EngravingWorker.perform_async(sample_engraving.id)
# end
