namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Adam Min",
                         email: "admin@communificiency.com",
                         password: "foobar",
                         password_confirmation: "foobar"
    )
    admin.toggle! :admin


    sherwin = User.create!(name: "Sherwin Yu",
                 email: "d@e.f",
                 password: "sherwin",
                 password_confirmation: "sherwin")
    9.times do |n|
      name  = Faker::Name.name
      email = "example2-#{n+1}@railstutorial.org"
      password  = "password"
      u = User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
      u.confirmed_at = Time.now
      u.save
    end
  end
end

