require "json"

module EngravingsHelper

  # return human readable date/time
  def created_time_ago(engraving)
    time_created = engraving.created_at
    "#{time_ago_in_words time_created} ago"
  end

  # convert stringified json of errors to <li>s of errors
  def parse_errors(json_string)
    errors = JSON.parse(json_string)
    errors_list = Array.new
    errors.each do |e|
      errors_list.push "line #{e["line"]}: #{e["msg"]}"
    end
    return errors_list
  end
end
