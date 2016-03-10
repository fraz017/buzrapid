# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.create :email => "admin@buzzrapid.com", :password => "password", :role_cd => 4
# User.create :email => "hr@buzzrapid.com", :password => "password", :role_cd => 3
# User.create :email => "director@buzzrapid.com", :password => "password", :role_cd => 2
# User.create :email => "manager@buzzrapid.com", :password => "password", :role_cd => 1
# User.create :email => "executive@buzzrapid.com", :password => "password", :role_cd => 0