/* Imports */
import * as am4core from "@amcharts/amcharts4/core";
import * as am4charts from "@amcharts/amcharts4/charts";


/* Chart code */
// Themes begin
am4core.useTheme(am4themes_animated);
// Themes end

// create chart
let chart = am4core.create("treemapchartdiv", am4charts.TreeMap);
chart.hiddenState.properties.opacity = 0;

chart.data = [{
  name: "Tech",
  children: [
    {
      name: "AAPL",
      value: 1000
    },
    {
      name: "GOOGL",
      value: 3000
    },
    {
      name: "FB",
      value: 1500
    }
  ]
},
{
  name: "Automotive",
  children: [
    {
      name: "TSLA",
      value: 1000
    },
    {
      name: "GE",
      value: 1300
    },
    {
      name: "F",
      value: 800
    }
  ]
},
{
  name: "Telecom",
  children: [
    {
      name: "ATT",
      value: 600
    },
    {
      name: "V",
      value: 900
    },
    {
      name: "CMCSA",
      value: 300
    }
  ]
},
{
  name: "Finance",
  children: [
    {
      name: "JPM",
      value: 800
    },
    {
      name: "SCHW",
      value: 900
    },
    {
      name: "BAC",
      value: 2000
    }
  ]
},
{
  name: "Aerospace",
  children: [
    {
      name: "BA",
      value: 2500
    }
  ]
}];

chart.colors.step = 2;

// define data fields
chart.dataFields.value = "value";
chart.dataFields.name = "name";
chart.dataFields.children = "children";
chart.layoutAlgorithm = chart.binaryTree;

chart.zoomable = false;

// level 0 series template
let level0SeriesTemplate = chart.seriesTemplates.create("0");
let level0ColumnTemplate = level0SeriesTemplate.columns.template;

level0ColumnTemplate.column.cornerRadius(10, 10, 10, 10);
level0ColumnTemplate.fillOpacity = 0;
level0ColumnTemplate.strokeWidth = 4;
level0ColumnTemplate.strokeOpacity = 0;

// level 1 series template
let level1SeriesTemplate = chart.seriesTemplates.create("1");
level1SeriesTemplate.tooltip.dy = - 15;
level1SeriesTemplate.tooltip.pointerOrientation = "vertical";

let level1ColumnTemplate = level1SeriesTemplate.columns.template;

level1SeriesTemplate.tooltip.animationDuration = 0;
level1SeriesTemplate.strokeOpacity = 1;

level1ColumnTemplate.column.cornerRadius(10, 10, 10, 10)
level1ColumnTemplate.fillOpacity = 1;
level1ColumnTemplate.strokeWidth = 4;
level1ColumnTemplate.stroke = am4core.color("#ffffff");

let bullet1 = level1SeriesTemplate.bullets.push(new am4charts.LabelBullet());
bullet1.locationY = 0.5;
bullet1.locationX = 0.5;
bullet1.label.text = "{name}";
bullet1.label.fill = am4core.color("#ffffff");
bullet1.interactionsEnabled = false;
chart.maxLevels = 2;


setInterval(function () {
  for (var i = 0; i < chart.dataItems.length; i++) {
    let dataItem = chart.dataItems.getIndex(i);
    for (var c = 0; c < dataItem.children.length; c++) {
      let child = dataItem.children.getIndex(c);
      child.value = child.value + Math.round(child.value * Math.random() * 0.4 - 0.2);
    }
  }
}, 2000)

