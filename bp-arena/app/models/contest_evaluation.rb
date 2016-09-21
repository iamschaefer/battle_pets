##
#
class ContestEvaluation < ApplicationRecord
  ##
  # Queues this contest evaluation up in a job.
  def start_job
    ContestEvaluationJob.perform_later(self)
    true
  end
end
