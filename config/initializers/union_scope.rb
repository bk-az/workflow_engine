module ActiveRecord::UnionScope
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def union_scope(*scopes)
      scopes.map(&:to_sql).join(' UNION ')
    end
  end
end
