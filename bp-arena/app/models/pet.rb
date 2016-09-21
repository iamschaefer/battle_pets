##
# Model of a pet. A contestant in a contest
class Pet < ApplicationRecord
  include ActiveModel::Model

  attr_accessor :agility, :strength, :wit, :senses, :experience

  after_initialize :start_job

  private

  def start_job
    # Right now we ignore the contest type. Add this in later
    ContestEvaluationJob.perform_now(self)
  end
end
