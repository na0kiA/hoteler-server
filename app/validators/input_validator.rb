class InputValidator < ActiveModel::Validator
  def validate(record)
    if options[:fields].any? { |field| record.send(field) =~ />|</ }
      record.errors.add :base, '「<」や「>」といった記号は使用できません'
    elsif options[:fields].any? { |field| record.send(field) =~ /(.)\1{4,}/ }
      record.errors.add :base, '同じ文字の連続は避けてください'
    end
  end
end
