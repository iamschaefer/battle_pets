require 'net/http'
##
# Job for evaluating contests. Generally, contest evaluation takes a long time, so all evaluation should be executed in
# a job
class ContestEvaluationJob < ApplicationJob
  queue_as :default

  def perform(contest_evaluation)
    pet1 = JSON.parse(contest_evaluation.challenger)
    pet2 = JSON.parse(contest_evaluation.challenged)

    evaluator = EvaluatorFactory.new_for_contest_type(contest_evaluation.contest_type, pet1, pet2)
    winner = evaluator.winner
    post_winner(winner, contest_evaluation)
  end

  private

  def post_winner(winner, contest_evaluation)
    contest_id = contest_evaluation.contest_id
    callback_host = contest_evaluation.callback_host
    uri = URI.join("http://#{callback_host}:3000", '/pet_contests/', "#{contest_id}/", 'complete.json')
    sleep(15.seconds)
    Net::HTTP.post_form(uri, winner_id: winner['id'])
  end
end
