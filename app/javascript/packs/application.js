import "bootstrap";
import "chatroom";

import { mainChart } from "components/mainchart";
const groupShow = document.querySelector('.groups.show');
if (groupShow) {
  mainChart();
}

import { initSweetalert } from '../plugins/init_sweetalert';

initSweetalert('#sweet-alert', {
  title: "A nice alert",
  text: "This is a great alert, isn't it?",
  icon: "success"
});
