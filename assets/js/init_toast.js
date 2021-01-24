export const InitToast = {
  mounted() {
    init()
  }
}

const init = () => {
  const toastEl = document.querySelector('.toast')
  if (toastEl && toastEl.innerText !== '') {
    toastEl.classList.add("mr-2")

    setTimeout(() => {
      toastEl.classList.toggle("-mr-64", "mr-2")
    }, 3000);
  }
}

init()
