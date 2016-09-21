#!/usr/bin/env ruby
require 'net/http'
require 'colorize'
require 'json'
require 'uri'

def parse_json_from(uri)
  response = Net::HTTP.get(uri)
  hash = JSON.parse(response)
  puts JSON.pretty_unparse(hash).to_s.green

  hash
end

begin
  puts 'Demoing BattlePets...'.red
  puts "We seeded some users pets. Let's take a look at the leader board..."

  sleep(5)

  uri = URI.parse('http://localhost:3000/pets.json')
  parse_json_from(uri)

  sleep(5)

  puts "Let's take our champion as our challenger..."
  sleep(5)
  uri = URI.parse('http://localhost:3000/pets/2.json')
  elmo = parse_json_from(uri)

  sleep(5)

  puts 'And choose an opponent..'
  sleep(5)
  uri = URI.parse('http://localhost:3000/pets/1.json')
  pickles = parse_json_from(uri)

  sleep(5)

  puts "Great. Let's have Pickles challenge Elmo to a fight."
  sleep(5)
  params = {'pet_contest[contest_type]': 'fight',
            'pet_contest[challenger_id]': elmo['id'],
            'pet_contest[challenged_id]': pickles['id']}

  sleep(5)

  puts "POST to the management service's /pet_contests/ with params #{params}"

  sleep(5)

  uri = URI.parse('http://localhost:3000/pet_contests.json')
  response = Net::HTTP.post_form(uri, params)
  puts response.body.to_s.green

  contest_id = JSON.parse(response.body)['id']

  puts 'Now, lets be a user who decides to accept the contest. This will kick off contest evaluation in the arena.'

  sleep(5)

  uri = URI.parse("http://localhost:3000/pet_contests/#{contest_id}/accept.json")
  puts "Posting to #{uri}"
  response = Net::HTTP.post_form(uri, {})

  sleep(5)

  puts response.body.to_s.green

  sleep(5)

  puts "You can see the contest's workflow state is 'in_arena'. That means its still evaluating in the arena service"
  puts 'This will run for a while so lets wait 30 seconds...'

  sleep(30)

  puts 'Okay, now lets check the state of the contest'
  uri = URI.parse("http://localhost:3000/pet_contests/#{contest_id}.json")
  puts "Getting from #{uri}"
  response = Net::HTTP.get(uri)
  puts response.to_s.green

  sleep(5)

  puts 'Looks like we have a winner. The winner id was 1'
  puts 'So, that means pickles won...'

  sleep(5)

  puts "Let's look at the pets again. First pickles..."

  sleep(5)

  uri = URI.parse('http://localhost:3000/pets/1.json')
  new_pickles = parse_json_from(uri)

  sleep(5)

  puts 'Then Elmo...'

  sleep(5)

  uri = URI.parse('http://localhost:3000/pets/2.json')
  new_elmo = parse_json_from(uri)

  sleep(5)

  puts "Pickles' experience went from #{elmo['experience']} to #{new_pickles['experience']}"
  puts "Elmo's experience went from #{pickles['experience']} to #{new_elmo['experience']}"

  sleep(5)

  puts "Let's check the leader board now..."

  sleep(5)

  uri = URI.parse('http://localhost:3000/pets.json')
  parse_json_from(uri)

  sleep(5)

  puts 'Good job pickles. Number 1 now!'

  puts 'Thanks for going through the demo!'.red

rescue => e
  puts "rescuing from #{e} , #{e.backtrace}"
end

