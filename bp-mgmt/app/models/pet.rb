##
# Model of a pet.
class Pet < ApplicationRecord
  DEFAULT_EXPERIENCE = 100
  PET_TYPES = %w(water wind fire earth).freeze
  BASE_ATTRIBUTES = { 'water' => { strength: 10, wit: 10, agility: 10, senses: 10, experience: DEFAULT_EXPERIENCE },
                      'wind' => { strength: 5, wit: 20, agility: 20, senses: 5, experience: DEFAULT_EXPERIENCE },
                      'fire' => { strength: 10, wit: 15, agility: 15, senses: 10, experience: DEFAULT_EXPERIENCE },
                      'earth' => { strength: 20, wit: 5, agility: 5, senses: 20, experience: DEFAULT_EXPERIENCE } }.freeze

  include Workflow

  belongs_to :user

  alias_attribute :to_s, :name

  scope :leaders, -> { order(experience: :desc).limit(20) }

  def self.pet_types
    PET_TYPES
  end

  def pet_contests
    PetContest.where(challenger_id: id).or(PetContest.where(challenged_id: id))
  end

  def self.new_by_type(attrs)
    attrs = attrs.merge(BASE_ATTRIBUTES[attrs['pet_type']])
    Pet.new(attrs)
  end

  ##
  # Inform the pet that it has been challenged. This method sends a message to the user with the details of the
  # challenge.
  def challenged!
    user.challenge_for_pet(pet_contests.last)
  end

  ##
  # Inform the pet model that it is now finished with its current contest
  def contest_complete
    contest = pet_contests.where(workflow_state: 'in_arena').last
    apply_experience!(contest)
  end

  workflow do
    state :idle do
      event :contesting, transitions_to: :in_contest
      event :contest_cancelled, transitions_to: :idle
    end
    state :in_contest do
      event :contest_complete, transitions_to: :idle
      event :contest_cancelled, transitions_to: :idle
    end
  end

  private

  ##
  # Applies experience to this pet based on the results of the last contest.
  def apply_experience!(contest)
    return nil if contest.nil? || contest.winner.nil?

    if contest.winner?(self)
      apply_winner_experience!(contest)
    else
      apply_loser_experience!(contest)
    end
    save!
  end

  def apply_winner_experience!(contest)
    self.experience += experience_from(contest).round(1)
  end

  def apply_loser_experience!(contest)
    self.experience += (experience_from(contest) / 2).round(1)
  end

  ##
  # Calculated a base experience from the contest. Still subject to modification by whether or not the pet won.
  #
  # Experience scales with the amount of experience already earned. More experience is earned if the opponent's experience
  # is higher, and less if the opponents experience is lower
  def experience_from(contest)
    opponent = contest.opponent_of(self)
    # The bigger the experience advantage, the less points we should award, and vice versa.
    difference_multiplier = opponent.experience.to_f / experience
    result = difference_multiplier * experience.to_f / 10

    # Add a base experience so rewards come fast early
    result += 10

    # Scale so that the higher the experience we are, the smaller % of total experience we get
    result /= Math.log(experience) / Math.log(100)

    result
  end
end
