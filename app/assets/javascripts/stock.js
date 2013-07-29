var trader_format_date = function(dateval){
var m_names = new Array("Jan", "Feb", "Mar",
"Apr", "May", "Jun", "Jul", "Aug", "Sep",
"Oct", "Nov", "Dec");

var d = new Date(dateval);
var curr_date = d.getDate();
var curr_month = d.getMonth();
var curr_year = d.getFullYear() - 2000;
return (curr_date + "-" + m_names[curr_month]
+ "-" + curr_year);
};

$(document).ready(function() {

  // var refresh_balance = function(){
  //   find the position
  //   create the html code
  //   append to the position
  //   var $user = $(this).closest('.useremail').html();
  //   var $newbal = $('<li/>');
  //   $('#newbal' + @auth.balance).after($useremail);
  // }

  var toggle_form = function(){
    $('.purchase').toggle();
    // return false;
  }


  var display_chart = function(){
    var symbol = $(this).closest('.stock_detail').find('.stock_symbol').html();
    var upsymbol = symbol.toUpperCase();
    var chartele = $('#graph_'+ upsymbol);
    if (chartele !== 'undefined') {
      chartele.remove();
    }
    if (!$(this).is(':checked')){
      return;
    }
    $.ajax({
      dataType: 'json',
      type: 'get',
      url: '/stocks/chartdata/' + symbol
    }).done(process_share);
  };

  var process_share = function(shares){
    var $chartele = $('<div/>');
    $chartele.attr('id', 'graph_' + shares[0].symbol);
    $('#stock_' + shares[0].symbol).after($chartele);

    new Morris.Line({
        element: 'graph_' + shares[0].symbol,
        data: shares,
        xkey: 'date',
        ykeys: ['close'],
        labels: ['Closing Price'],
        dateFormat: trader_format_date,
        xLabelFormat: trader_format_date
    });
}
  $(document).on('click', '.share_chart :checkbox', display_chart);
  $(document).on('click','.purchase',toggle_form);

});

