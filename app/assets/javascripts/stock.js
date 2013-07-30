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

  var toggle_form = function(){
    $('.purchase').toggle();
  }


  var process_share = function(){
    var symbol = $(this).closest('.stock_detail').find('.stock_symbol').html();
    var upsymbol = symbol.toUpperCase();
    var chart_element = $('#graph_'+ upsymbol);

    // Remove the graph if graph is displayed
    if (chart_element !== 'undefined') {
      chart_element.remove();
    }

    // If checkbox is not checked then there is nothing to do
    if (!$(this).is(':checked')){
      return;
    }

    // get historical data from server
    $.ajax({
      dataType: 'json',
      type: 'get',
      url: '/stocks/chartdata/' + symbol
      }).done(display_chart);
  };

  var display_chart = function(shares){
    // create chart element
    var $chart_element = $('<div/>');
    $chart_element.attr('id', 'graph_' + shares[0].symbol);

    // append sock to chart element
    $('#stock_' + shares[0].symbol).after($chart_element);

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

  $(document).on('click', '.share_chart #checkbox', process_share);
  $(document).on('click','.purchase',toggle_form);

});

