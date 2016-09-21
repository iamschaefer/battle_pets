# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user1 = User.create!(email: 'user@email.com', password: 'password')
user2 = User.create!(email: 'iamschaefer@gmail.com', password: 'password')

Pet.create!(name: 'Pickles', pet_type: 'water', strength: 22, wit: 1, agility: 1, senses: 5, experience: 20, user: user1)
Pet.create!(name: 'Elmo', pet_type: 'fire', strength: 2, wit: 16, agility: 7, senses: 3, experience: 21, user: user1)

Pet.create!(name: 'Rocky', pet_type: 'rock', strength: 22, wit: 1, agility: 1, senses: 5, experience: 5, user: user2)
Pet.create!(name: 'Gazorpazorp', pet_type: 'water', strength: 22, wit: 10, agility: 12, experience: 5, senses: 5, user: user2)

ArenaService.create!(address: 'localhost', port: '3001', version: 1)
