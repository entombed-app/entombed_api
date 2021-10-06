# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Recipient.destroy_all

user_1 = User.create!(email: 'ex@ample.com', name: 'Elder Bobby', date_of_birth: '1999/01/02', obituary: 'Tedious and brief', password: 'password')

user_1.profile_picture.attach(
    io: File.open('./public/profile_pictures/profile-picture.png'),
    filename: 'profile-picture.png',
    content_type: 'application/png'
)

user_1.executors.create!(name: 'younger bobby', email: 'bob@bee.com', phone: '888-999-1111')

user_1.recipients.create!(name: 'Uncle bobby', email: 'galloway.taylor@gmail.com')
user_1.recipients.create!(name: 'Aunty bobby', email: 'noah.zinter@gmail.com')
user_1.recipients.create!(name: 'Gary bobby', email: 'garybobby@test.com')
user_1.recipients.create!(name: 'Jerry bobby', email: 'Jerrybobby@test.com')
user_1.recipients.create!(name: 'Cousin bobby', email: 'cous@test.com')