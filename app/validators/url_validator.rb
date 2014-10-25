class  UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    url = /\A(http|https):\/\/(([a-z0-9]+\:)?[a-z0-9]+\@)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\z/ix
    record.errors[attribute] << (options[:message] || 'is not valid url') unless value =~ url
  end
end