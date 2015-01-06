module Moderation
  class AbstractStorage

    def insert data
      raise NotImplementedError
    end

    def all options = {}
      raise NotImplementedError
    end

    def search key, value
      raise NotImplementedError
    end

    def moderation_required?
      raise NotImplementedError
    end

    def clean!
      raise NotImplementedError
    end

  end
end
