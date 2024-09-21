import { Controller } from "@hotwired/stimulus"

/*
	We're gonna use the File API, to show the files that the user uploads inside
	that preview box. If there is just one file it will take up the entire box
	otherwise it will be a carousel?
*/
export default class extends Controller {
		static targets = ["preview", "media"]
		// want to access the `FileList` through the `change` event

		// TODO: Implement a slider for multiple images.
		previewMedia() {
				// Not implemented just yet...
				let files = Array.from(this.mediaTargets[0].files);
				if (files === undefined) {
						this.previewTarget.textContent = "Sorry! No preview is available for this file!";
				} else {
						for (var i = files.length - 1; i >= 0; i--) {
								if (!files[i].type.startsWith("image/")) {
										continue;
								}
								const currentFile = files[i];
								const img = document.createElement("img");
								img.classList.add("object-contain");
								// The <img> that replaces the initial target is the new target
								img.setAttribute("data-media-preview-target", "preview")
								img.file = currentFile;
								const container = this.previewTarget.parentNode;
								container.replaceChild(img, this.previewTarget);
								const reader = new FileReader();
								reader.onload = (e) => {
										img.src = e.target.result;
								};
								reader.readAsDataURL(currentFile);
						}
				}
		}
}

