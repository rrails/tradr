# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  password_digest :string(255)
#  balance         :decimal(, )
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  has_secure_password
  attr_accessible :email, :password, :balance, :password_confirmation
  attr_accessor :totalbal
  has_many :stocks, :inverse_of => :user

  def purchase_stock(symbol,shares)
      quote = Stock.quote(symbol)
      if (quote * shares) <= self.balance
        #find the stock if it exists or creare a new stock
        @stock = Stock.where(:symbol => symbol).first || Stock.new(:symbol => symbol, :shares => 0)
        @stock.shares += shares
        @stock.save
        #update the user balance
        self.balance -= (quote * shares)
        #link the stock to user
        self.stocks << @stock if self.stocks.exclude?(@stock)
        self.save
      else
        self.errors.add(:base, "not sufficient money")
      end
  end

  def position
    self.stocks.map{|s| Stock.quote(s.symbol) * s.shares}.reduce(:+) || 0
  end

  def total
    self.position + self.balance
  end

end
