class User < ActiveRecord::Base
  attr_accessible :email, :username, :password

  validates :email, :username, :password, :presence => true
  validates :email, :uniqueness => true

  has_many :contacts

  def to_param
    "#{self.id}-#{self.username}"
  end
  # before_create :gen_token
  #
  # def gen_token
  #   self.token =
  # end
end
