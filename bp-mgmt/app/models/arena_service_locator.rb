##
# Singleton class responsibile for picking a good ArenaService for contest evaluation
class ArenaServiceLocator
  include Singleton

  ##
  # This is basically a stub so that we could easily insert a load balancer and/or service discovery mechanism. Right
  # now we only have one.
  def self.locate
    ArenaService.first
  end
end
