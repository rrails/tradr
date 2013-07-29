class StocksController < ApplicationController
  before_filter :only_authorised

  def index
    @stocks = @auth.stocks
  end

  def new
    @stock = Stock.new
  end

  def create
    @stock = Stock.create(params[:stock])
    purchase_price = get_purchase_price(@stock.symbol)
    total_price = purchase_price * @stock.shares
    if total_price < @auth.balance
      @auth.balance = @auth.balance - total_price
    @auth.save
    @auth.stocks << @stock


    end

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
    symbol = symbol.upcase
    price = Stock.quote(symbol)
    # price = YahooFinance::get_quotes(YahooFinance::StandardQuote, symbol)[symbol].lastTrade
    return price
  end



  private
  def only_authorised
    redirect_to(root_path) if @auth.nil?
  end

end
