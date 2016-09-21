##
# Our model of a user with an email. password, ability to log in, etc.
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  has_many :pets

  alias_attribute :to_s, :email

  # TODO: need to update this so our user ids are not sequential

  def challenge_for_pet(contest)
    # Do something to notify the user of a challenge!
  end
end
