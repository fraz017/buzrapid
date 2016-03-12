class Company < ActiveRecord::Base
	has_many :users, :dependent => :destroy
	has_many :projects, :dependent => :destroy
	validates_presence_of :name
end
