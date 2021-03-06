/**
 * ---------------------------------------
 * This demo was created using amCharts 4.
 *
 * For more information visit:
 * https://www.amcharts.com/
 *
 * Documentation is available at:
 * https://www.amcharts.com/docs/v4/
 * ---------------------------------------
 */

// Themes begin
function mainChart() {
  am4core.useTheme(am4themes_animated);
  // Themes end

  // Create chart instance
  var chart = am4core.create("mainchartdiv", am4charts.XYChart);

  // Add data
  chart.data = generatechartData();
  function generatechartData() {
    var chartData = [];
    var firstDate = new Date();
    firstDate.setDate( firstDate.getDate() - 30 );
    var visits = -40;
    var b = 0.6;
    for ( var i = 0; i < 150; i++ ) {
      // we create date objects here. In your data, you can have date strings
      // and then set format of your dates using chart.dataDateFormat property,
      // however when possible, use date objects, as this will speed up chart rendering.
      var newDate = new Date( firstDate );
      newDate.setDate( newDate.getDate() + i );
      if(i > 80){
          b = 0.4;
      }
      visits += Math.round((Math.random()<b?1:-1)*Math.random()*10);

      chartData.push( {
        date: newDate,
        visits: visits
      } );
    }
    return chartData;
  }

  // Create axes
  var dateAxis = chart.xAxes.push(new am4charts.DateAxis());
  dateAxis.startLocation = 0.5;
  dateAxis.endLocation = 0.5;
  dateAxis.renderer.grid.template.disabled = true;
  dateAxis.renderer.labels.template.disabled = true;
  dateAxis.cursorTooltipEnabled = false;

  // Create value axis
  var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());
  valueAxis.renderer.grid.template.disabled = true;
  valueAxis.renderer.labels.template.disabled = true;
  valueAxis.cursorTooltipEnabled = false;

  // Create series
  var series = chart.series.push(new am4charts.LineSeries());
  series.dataFields.valueY = "visits";
  series.dataFields.dateX = "date";
  series.stroke = '#219975'
  series.strokeWidth = 3;
  series.tooltipText = "{dateX}\n${valueY.value}";
  series.tooltip.getFillFromObject = false;
  series.tooltip.background.fill = "#8B81D2";
  series.fillOpacity = 0.1;

  // Create a range to change stroke for values below 0
  var range = valueAxis.createSeriesRange(series);
  range.value = 0;
  range.endValue = -1000;
  range.contents.stroke = '#EA6D3F';
  range.contents.fill = range.contents.stroke;
  range.contents.strokeOpacity = 0.7;
  range.contents.fillOpacity = 0.1;

  // Add cursor
  chart.cursor = new am4charts.XYCursor();
  chart.cursor.behavior = "selectX";

  chart.cursor.lineX.stroke = "#8B81D2";
  chart.cursor.lineX.strokeWidth = 4;
  chart.cursor.lineX.strokeOpacity = 1;
  chart.cursor.lineX.strokeDasharray = "";

  chart.cursor.lineY.stroke = "#8B81D2";
  chart.cursor.lineY.strokeWidth = 4;
  chart.cursor.lineY.strokeOpacity = 0;
  chart.cursor.lineY.strokeDasharray = "";

  // chart.cursor.xAxis = dateAxis;
  // chart.scrollbarX = new am4core.Scrollbar();

  // chart.cursor.events.on("selectended", function(ev) {
  //   let range = ev.target.yRange;
  //   let axis = ev.target.chart.yAxes.getIndex(0);
  //   let from = axis.getPositionLabel(axis.toAxisPosition(range.start));
  //   let to = axis.getPositionLabel(axis.toAxisPosition(range.end));
  //   series.tooltipText = from;
  // });

  // Create info block
  let info = chart.plotContainer.createChild(am4core.Container);
  info.width = 320;
  info.height = 60;
  info.x = 10;
  info.y = 10;
  info.padding(10, 10, 10, 10);
  info.background.fill = am4core.color("#000");
  info.background.fillOpacity = 0.1;
  info.layout = "grid";

  // Add labels to it
  function createLabel(field, title) {
    let titleLabel = info.createChild(am4core.Label);
    titleLabel.text = title + ":";
    titleLabel.marginRight = 5;
    titleLabel.minWidth = 60;

    let valueLabel = info.createChild(am4core.Label);
    valueLabel.id = field;
    valueLabel.text = "-";
    valueLabel.minWidth = 50;
    valueLabel.marginRight = 30;
    valueLabel.fontWeight = "bolder";
  }

  createLabel("date", "DATE");
  createLabel("value", "VALUE");

  // Update field values
  function updateValues(dataItem) {
    am4core.array.each(["date", "value"], function(key) {
      let series = chart.series.getIndex(0);
      series.dataFields.valueY = "visits";
      series.dataFields.dateX = "date";
      let label = chart.map.getKey(key);
      label.text = chart.numberFormatter.format(dataItem[key + "ValueX"]);
      // Color controls below
      // if (dataItem.droppedFromOpen) {
      //   label.fill = series.dropFromOpenState.properties.fill;
      // }
      // else {
      //   label.fill = series.riseFromOpenState.properties.fill;
      // }
    });
  }

  // Set initial values

  chart.events.on("ready", function(ev) {
    updateValues(series.dataItems.last);
  });

  // Follow cursor

  chart.cursor.events.on("cursorpositionchanged", function(ev) {
    var dataItem = dateAxis.getSeriesDataItem(
      series,
      dateAxis.toAxisPosition(chart.cursor.xPosition),
      true
    );
    updateValues(dataItem);
  });

  // Reset when cursor leaves

  chart.cursor.events.on("hidden", function(ev) {
    updateValues(series.dataItems.last);
  });
}

export { mainChart };
