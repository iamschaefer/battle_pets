require 'net/http'

##
# Model of information necessary to talk to an arena service.
class ArenaService < ApplicationRecord
  ##
  # Request a contest via this arena service.
  def new_contest!(contest)
    uri = URI.join("http://#{address}:#{port}", '/contest_evaluations/')
    contest_id = contest.id
    challenger = contest.challenger
    challenged = contest.challenged
    contest_type = contest.contest_type
    params = { contest_id: contest_id,
               challenger: challenger.to_json,
               challenged: challenged.to_json,
               contest_type: contest_type }
    response = Net::HTTP.post_form(uri, params)
    return true if response.code == '201'

    false
  end
end
