module Moderation
  class AbstractCoercer

    def dump options={}
      raise NotImplementedError
    end

    def load options={}
      raise NotImplementedError
    end

  end
end
