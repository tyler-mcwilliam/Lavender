import swal from 'sweetalert2';

const initSweetalert = (selector, options = {}) => {
  console.log("hellooooooooo")
  const swalButton = document.querySelector(selector);
  if (swalButton) { // protect other pages
    swalButton.addEventListener('click', () => {
      swal(options);
    });
  }
};

export { initSweetalert };