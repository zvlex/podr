FactoryGirl.define do
  factory :category do
    title "RubyonRails"
    description "Ruby Framework"

    factory :invalid_category do
      title nil
      description nil
      user_id nil
    end
  end
end
