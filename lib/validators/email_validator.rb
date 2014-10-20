class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A[^@\s]+@([^@\s\.]+\.)+[^@\s\.]+\z/i
      record.errors.add(attribute, options[:message] || :email_format)
    end
  end
end
