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
    age 1
    category nil
  end
end
