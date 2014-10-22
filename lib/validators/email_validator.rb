class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A[^@\s]+@([^@\s\.]+\.)+[^@\s\.]+\z/i
      record.errors.add(attribute, options[:message] || 'this is not an email')
    end
  end
end
