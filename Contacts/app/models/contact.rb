class Contact < ActiveRecord::Base
  attr_accessible :email, :mail_address, :name, :phone, :user_id, :is_favorite

  validates :email, :mail_address, :name, :phone, :presence => true
  validates :email, :uniqueness => true

  belongs_to :user
end

#curl -X POST -d "contact[name]=cj&contact[email]=cj@cj.com&contact[mail_address]=160%20Folsom%20St.&contact[user_id]=2&contact[phone]=1234567890" http://localhost:3000/users/2/contacts/1


# curl -d "user[username]=cj&user[email]=cj@cjavil.com" http://localhost:3000/users

# curl -X DELETE http://localhost:3000/users/2/contacts/1


# curl -X POST -d "contact[name]=sonny&contact[email]=cj@cj.com&contact[mail_address]=160%20Folsom%20St.&contact[user_id]=2&contact[phone]=1234567890" http://localhost:3000/users/7/contacts