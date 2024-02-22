module Base
  extend Concern

  # included do
  # end

  class_methods do
    def frames(fps)
      define_method :frames do
        fps
      end
    end

    def weight(weight)
      define_method :weight do
        weight
      end
    end

    def sprite(path = nil, &block)
      define_method(:sprite) do
        path = instance_eval(&block) if block

        File.join("sprites", path)
      end
    end
  end
end
