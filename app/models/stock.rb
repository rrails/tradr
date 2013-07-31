# == Schema Information
#
# Table name: stocks
#
#  id             :integer          not null, primary key
#  symbol         :string(255)
#  shares         :integer
#  purchase_price :decimal(, )
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Stock < ActiveRecord::Base
  attr_accessible :symbol, :shares, :purchase_price
  attr_accessor :current_val, :purchase_val
  belongs_to :user, :inverse_of => :stocks

  def val
    self.current_val = Stock.quote(self.symbol) * self.shares
    self.purchase_val = self.purchase_price  * self.shares
  end

  def Stock.quote(symbol)
    symbol = symbol.upcase
    YahooFinance::get_quotes(YahooFinance::StandardQuote, symbol)[symbol].lastTrade
  end

  def Stock.historical(symbol)
    symbol = symbol.upcase
    return YahooFinance::get_HistoricalQuotes_days(symbol,30)
  end

  before_save :upcase_symbol, :get_purchase_price
  private
  def upcase_symbol
    self.symbol = self.symbol.upcase
  end

  def get_purchase_price
    self.purchase_price = Stock.quote(self.symbol)
  end

end
