# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Message.destroy_all
User.destroy_all

fred = User.create(
  name: 'Fred',
  email: 'fred@guild.com'
)

tina = User.create(
  name: 'Tina',
  email: 'tina@guild.com'
)

joe = User.create(
  name: 'Joe',
  email: 'joe@guild.com'
)

# Joe sends messages to Fred and Tina
2.times { Message.create(sender: joe, recipient: fred, body: Faker::Lorem.sentence) }
2.times { Message.create(sender: joe, recipient: tina, body: Faker::Lorem.sentence) }

# Tina will have too many messages, based on 100 count limit
105.times { Message.create(sender: tina, recipient: fred, body: Faker::Lorem.sentence) }

3.times { Message.create(sender: fred, recipient: tina, body: Faker::Lorem.sentence) }

# Fred will have some messages that are too old, based on 30 day recency limit
first_message = Message.where(sender: fred).first
first_message.created_at = 45.days.ago
first_message.save
last_message = Message.where(sender: fred).last
last_message.created_at = 45.days.ago
last_message.save