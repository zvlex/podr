FactoryGirl.define do
  factory :category do
    title "RubyonRails"
    description "Ruby Framework"
    user_id { rand(21) }

    factory :invalid_category do
      title nil
      description nil
      user_id nil
    end
  end
end
