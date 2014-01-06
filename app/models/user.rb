# -*- coding: utf-8 -*-
class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :trackable

  ## Omniauthable
  field :twitter_id,  type: String
  field :name,        type: String
  field :nick,        type: String
  field :profile,     type: String
  field :icon_url,    type: String
  
  field :access_token,  type: String
  field :access_secret, type: String

  ## Database authenticatable
  # field :email,              :type => String, :default => ""
  # field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  # field :reset_password_token,   :type => String
  # field :reset_password_sent_at, :type => Time

  ## Rememberable
  # field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  field :authentication_token, type: String

  has_many :poked, class_name: "Poke", inverse_of: :author
  has_many :targeted, class_name: "Poke", inverse_of: :target

  def friend?(screen_name)
    begin
      friendship = self.client.friendship(self.name, screen_name)[:source]
      return (friendship[:following] && friendship[:followed_by])
    rescue
      return false
    end
  end

  def invite(screen_name)
    begin
      if self.user(screen_name)
        self.client.update("@#{screen_name} つんつん http://tuntun.herokuapp.com/")
      end
    end
  end

  def user(screen_name)
    begin
      self.client.user(screen_name)
    rescue
      false
    end
  end

  def client
    client = Twitter::Client.new(
                                 consumer_key:       Settings.twitter.key ,
                                 consumer_secret:    Settings.twitter.secret,
                                 oauth_token:        self.access_token,
                                 oauth_token_secret: self.access_secret
                                 )
  end
end
