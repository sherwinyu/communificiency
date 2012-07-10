namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Adam Min",
                         email: "admin@istrator.com",
                         password: "foobar",
                         password_confirmation: "foobar"
    )
    admin.toggle! :admin


    sherwin = User.create!(name: "Sherwin Yu",
                 email: "a@b.c",
                 password: "sherwin",
                 password_confirmation: "sherwin")
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end

