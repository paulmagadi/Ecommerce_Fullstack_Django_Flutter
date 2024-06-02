const toggleButton = document.getElementById('toggler');
const navigationLinks = document.getElementById('navbar-links');
const navbar = document.querySelector('.navbar-mobile');

toggleButton.addEventListener('click', () => {
    navigationLinks.classList.toggle('show');
    navbar.classList.add('border');

    if (navigationLinks.classList.contains('show')) {
        toggleButton.innerHTML = '&times;'; // Change to times symbol
    } else {
        toggleButton.innerHTML = '&#8801;'; // Change back to menu symbol
    }
});




