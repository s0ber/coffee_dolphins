FactoryGirl.define do
  factory :landing do
    title 'My test landing'
    sequence(:slug) { |n| "test-slug-#{n}" }
    category_id 1
    position_id 1
    price 10.00
    discount 5.00

    trait :published do
      _status :published
      short_description 'test'
      subheader_title 'test'
      description_title 'test'
      description_text 'test'
      advantages_title 'test'
      advantages_text 'test'
      why_question 'test'
      reviews_title 'test'
      reviews_footer 'test'
      video_id 'test'
      color 1
      apishops_article_id 1
      apishops_site_id 1
      html_title 'test'
      meta_description 'test'
      footer_title 'test'
    end
  end
end
