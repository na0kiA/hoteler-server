class XssValidator < ActiveModel::Validator
  def validate(record)
    if options[:fields].any? { |field| record.send(field) =~ />|</ }
      record.errors.add :base, '「<」や「>」といった記号は使用できません'
    end
  end
end
