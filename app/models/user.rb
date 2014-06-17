require "securerandom.rb"

class User < ActiveRecord::Base
  has_many :photos
  has_many :comments
  has_many :tags

  validates :login,      uniqueness: 
                         { case_sensitive: false, 
                           message: "already in use (case-insensitive!)"}
  validates :login,      presence: true
  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :password,   presence: true, confirmation: true # checks that equal
  validates :password_confirmation, presence: true

  # Public: Method which checks whether a user-supplied password matches that
  #         stored in the database. Uses SHA2/salting, for security. Returns a
  #         boolean whether the supplied password is correct
  def password_valid?(input_pw)
    input_digest = compute_SHA2(self.salt + input_pw)
    input_digest == self.password_digest
  end

  # Public: Accessor which returns the password (as entered by user on a form)
  def password
    @password
  end

  # Public: Takes as input a plain text password and computes/sets the instance
  #         salt and password_digest attributes accordingly
  def password=(raw_pw)
    @password = raw_pw # for accessor, self.password does NOT work!
    self.salt = new_salt
    self.password_digest = compute_SHA2(self.salt + raw_pw.to_s)
  end

  # Public: Convenience method to get a user's full name
  #         Returns a String in the format "first_name last_name"
  def full_name
    %Q|#{self.first_name} #{self.last_name}|
  end

  private
  # Private: Convenience method which generates a random hex password salt of 
  #          the length 2*n (default: generates String with size of 42)
  def new_salt(n=21)
    SecureRandom.hex(n)
  end

  # Private: Convenience method that computes a 512 bit SHA2 hash string for the
  #          input String
  def compute_SHA2(str)
    Digest::SHA2.hexdigest(str, bitlen=512) 
  end
end
