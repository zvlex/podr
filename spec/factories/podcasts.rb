FactoryGirl.define do
  factory :podcast do
    title "MyString"
    sub_title "MyString"
    url "http://testing.io"
    itunes_image "MyString"
    description "MyText"
    author "MyString"
    owners_email "MyString"
    atom_link "MyString"
    keywords "MyText"
    user_id 1
    category_id 1

    factory :invalid_podcast do
      title nil
      sub_title nil
      url nil
      itunes_image nil
      description nil
      author nil
      owners_email nil
      atom_link nil
      keywords nil
      user_id nil
      category_id nil
    end
  end
end
