class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
	as_enum :role, executive: 0, manager: 1, director: 2, hr: 3, admin: 4        
	belongs_to :company
end
