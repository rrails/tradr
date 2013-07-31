class StocksController < ApplicationController
  before_filter :only_authorised

  def index
    @stocks = @auth.stocks
    @stocks.each do |stock|
      stock.val
    end
  end

  def new
    @stock = Stock.new
  end

  def create
    symbol = params[:stock][:symbol].upcase
    shares = params[:stock][:shares].to_i
    @auth.purchase_stock(symbol,shares)
    respond_to do |format|
      format.html {redirect_to(stocks_path)}
      format.js {render :create}
    end
  end

  def chartdata
      render :json => Stock.historical(params[:symbol])
  end

  private
  def only_authorised
    redirect_to(root_path) if @auth.nil?
  end

end
