##
# Singleton factory for creating contest evaluators
class EvaluatorFactory
  include Singleton

  def self.new_for_contest_type(type, *attrs)
    if type == 'fight'
      return FightEvaluator.new(*attrs)
    elsif type == 'race'
      return RaceEvaluator.new(*attrs)
    elsif type == 'chess'
      return ChessEvaluator.new(*attrs)
    end
    raise "No evaluator for contest type #{type}"
  end
end
