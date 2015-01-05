module Moderation
  class AbstractStorage

    def insert data
      raise NotImplementedError
    end

    def all options = {}
      raise NotImplementedError
    end

  end
end
