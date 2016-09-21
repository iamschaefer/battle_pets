##
# Model for a contest between two pets
class PetContest < ApplicationRecord
  CONTEST_TYPES = %w(fight race chess).freeze
  STATES = %w(challenged accepted in_arena cancelled completed).freeze

  include Workflow

  belongs_to :challenger, class_name: Pet, foreign_key: 'challenger_id'
  belongs_to :challenged, class_name: Pet, foreign_key: 'challenged_id'
  belongs_to :winner, class_name: Pet, foreign_key: 'winner_id', optional: true

  validates :challenged, presence: true
  validates :challenger, presence: true
  validates :contest_type, presence: true, inclusion: CONTEST_TYPES

  after_create :challenge_pet

  scope :by_user, ->(user_id) { joins(:challenger).joins(:challenged).where('pets.user_id = ?', user_id) }
  scope :by_pet, ->(pet_id) { where('challenger_id = ? OR challenged_id = ?', pet_id, pet_id) }

  def challenge_pet
    return unless current_state == :new
    challenged.challenged!
    challenged!
  end

  def complete(winner_id)
    self.winner = Pet.find_by_id(winner_id)
    save
    challenger.contest_complete!
    challenged.contest_complete!
    save
  end

  def cancel
    save
  end

  ##
  # Returns true if the given pet won this contest. Otherwise, returns false.
  #
  # Raises an error if the given pet was not in the contest
  def winner?(pet)
    raise "#{pet} was not in this contest" unless in_contest?(pet)
    winner_id == pet.id
  end

  ##
  # Returns true if the given pet was in this contest, false otherwise.
  def in_contest?(pet)
    pet.id == challenger.id || pet.id == challenged.id
  end

  ##
  # Returns the other pet in this contest. Raises an error if the given pet was not in this contest
  def opponent_of(pet)
    raise "#{pet} was not in this contest" unless in_contest?(pet)
    return challenger if pet.id != challenger.id
    challenged
  end

  workflow do
    state :new do
      event :challenged, transitions_to: :challenged
    end
    state :challenged do
      event :accept, transitions_to: :in_arena
      event :cancel, transitions_to: :cancelled
    end
    state :accepted do
      event :start_contest, transitions_to: :in_arena
      event :cancel, transitions_to: :cancelled
    end
    state :in_arena do
      on_entry do
        request_contest_evaluation
      end
      event :complete, transitions_to: :completed
      event :cancel, transitions_to: :cancelled
    end
    state :cancelled do
      on_entry do
        challenger.contest_cancelled!
        challenged.contest_cancelled!
      end
    end
    state :completed
  end

  private

  def request_contest_evaluation
    challenger.contesting!
    challenged.contesting!
    cancel! unless ArenaServiceLocator.locate.new_contest!(self)
  end
end
