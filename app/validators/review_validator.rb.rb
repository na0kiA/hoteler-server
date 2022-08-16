class ReviewValidator < ActiveModel::Validator
  def validate(record)
    if record.match?(/^りんご/)
      record.errors.add :base, "これは悪人だ"
    end
  end
end
