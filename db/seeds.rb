User.create!(name: "ExampleUser",
  email: "exampleemail@gmail.com",
  password: "foobar",
  password_confirmation: "foobar",
  admin: true)
50.times do |n|
name = Faker::Name.name
email = "exampleemail-#{n+1}@gmail.com"
password = "password"
User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password)
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  user.each { |user| user.microposts.create!(content: content)}
end
