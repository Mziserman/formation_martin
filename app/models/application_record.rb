class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.try_sql(sql, vars = [])
    result = connection.exec_query(
      ActiveRecord::Base.send(:sanitize_sql_array, [sql] + vars)
    )
    result.rows
  end
end
