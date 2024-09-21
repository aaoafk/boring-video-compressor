
/*
  <!-- TODO: Convert to stimulus controller? -->
  <script>
    const toggleNav = document.getElementById('toggle-nav');
    const navLinks = document.getElementById('nav-links');

    toggleNav.addEventListener('click', () => {
      navLinks.classList.toggle('hidden');
    });
  </script>
*/

import { Controller } from "@hotwired/stimulus"

/*
	We're gonna use the File API, to show the files that the user uploads inside
	that preview box. If there is just one file it will take up the entire box
	otherwise it will be a carousel?
*/
export default class extends Controller {
		static targets = ["burger", "hotdog"]

		burgerize() {
				// implement
		}
}

