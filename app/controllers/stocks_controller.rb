class StocksController < ApplicationController
  before_filter :only_authorised

  def index
    @stocks = @auth.stocks
    @stocks.each do |stock|
      Stock.val(stock)
    end
  end

  def new
    @stock = Stock.new
  end

  def create

    symbol = params[:stock][:symbol].upcase
    shares = params[:stock][:shares].to_i
    purchase_price = get_purchase_price(symbol)
    total_price = purchase_price * shares
    if total_price < @auth.balance
      @stock = Stock.where(:symbol => symbol).first || Stock.new(:symbol => symbol, :shares => 0)
      @stock.shares += shares
      @stock.save
      @auth.balance -= total_price
      @auth.stocks << @stock
      @auth.save
    # else
      # @auth.errors.add(:base, "not sufficient money")
    end
binding.pry

    respond_to do |format|
      format.html {redirect_to(stocks_path)}
      format.js {render :create}
    end
  end

  def chartdata
    symbol = params[:symbol];
    result = YahooFinance::get_HistoricalQuotes_days(symbol,30)
    render :json => result
  end

  def get_purchase_price(symbol)
    price = Stock.quote(symbol)
    return price
  end

  private
  def only_authorised
    redirect_to(root_path) if @auth.nil?
  end

end
