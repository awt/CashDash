var DashboardController = function(){
  function loadChart(chart_name){
    $.get('/api/chart', { name: chart_name}, function( chart_config ){
      chart_config['chart']['renderTo'] = chart_name;
      var chart = new Highcharts.Chart(chart_config);
    });
  }
  var that = {
    init: function(){
      $.get('/api/chart_names', {}, function(chart_names){
        for( var i=0; i < chart_names.length; i++)
        {
          loadChart(chart_names[i]);
        }
      });
    }, 

  };
 
  
  return that;
};

var dashboard_controller = DashboardController();
