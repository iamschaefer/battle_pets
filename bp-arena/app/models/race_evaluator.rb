##
# Evaluator for race contests. Initialize with competitor1 and competitor2 attributes, then call winner to get
# the winning competitor returned.
class RaceEvaluator
  ##
  # Create a new evaluator for the given competitors. Call #winner on this instance to get the champion returned
  def initialize(competitor1, competitor2)
    @competitor1 = competitor1
    @competitor2 = competitor2
  end

  def winner
    score1 = score(@competitor1)
    score2 = score(@competitor2)

    exp1 = @competitor1['experience'].to_f
    exp2 = @competitor2['experience'].to_f
    if score1 == score2 && exp1 == exp2
      SecureRandom.random_number(2).zero? ? @competitor1 : @competitor2
    elsif score1 == score2
      exp1 > exp2 ? @competitor1 : @competitor2
    elsif score1 > score2
      @competitor1
    else
      @competitor2
    end
  end

  private

  def score(competitor)
    competitor['agility'].to_f
  end
end
