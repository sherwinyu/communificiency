FactoryGirl.define do

  sequence :project_name do |n|
    "project numero #{n}"
  end

  sequence :reward_name do |n|
    "project reward numero #{n}"
  end

  sequence :reward_minimum_contribution do |n|
    n * 15
  end

  sequence :reward_short_description do |n|
    "project reward short description numero #{n}"
  end

  sequence :reward_long_description do |n|
    "project reward long-g-g-g-g-g-g-g--g-g-g-g-g description numero #{n}"
  end

  sequence :email do |n|
    "max#{n}@communificiency.com"
  end


  factory :user do
    name "Maximilian Webstah"
    email { FactoryGirl.generate :email }
    password "ilovekale"
    password_confirmation "ilovekale"
  end

  factory :project do
    name { FactoryGirl.generate :project_name }
    short_description "Just a short description less than 200 words"
    long_description "Just a long description less than 200 words"
    funding_needed 1000

    factory :project_with_rewards do

      ignore do
        rewards_count 3
      end

      # after(:create) do |project, evaluator|
      # FactoryGirl.create_list(:reward, evaluator.rewards_count, project: project)
      # end

      after_create do |instance|
        FactoryGirl.create_list(:reward, 3, project: instance)
      end

      after_create { |instance| instance.reload }

    end
  end

  factory :reward do
    name { FactoryGirl.generate(:reward_name) }
    short_description { FactoryGirl.generate :reward_short_description }
    long_description { FactoryGirl.generate :reward_long_description }
    minimum_contribution  { FactoryGirl.generate :reward_minimum_contribution }
    limited_quantity 3
  end

  factory :contribution do
    amount { 55 }
    project
    user
    payment

    factory :contribution_with_reward do
      ignore do
        
      end
      reward  nil
    end

  end

  factory :payment do
    transaction_id 1
    caller_reference 1
    transaction_provider "AMAZON"
    transaction_status Payment::STATUS_CREATED
  end
end

