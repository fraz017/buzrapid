class Company < ActiveRecord::Base
	has_many :users
	has_many :projects
	validates_presence_of :name
end
