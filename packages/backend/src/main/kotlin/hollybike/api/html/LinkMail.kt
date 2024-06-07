package hollybike.api.html

import kotlinx.html.*

fun HTML.linkMail(link: String, association: String) {
	head {
		style {
			+ """
				* {
					font-family: Helvetica, sans-serif;
					font-weight: bold;
				}
				
				.card {
					background-color: rgb(204, 208, 218);
					padding: 16px 0;
					border: solid 2px #5c5f77;
					border-radius: 4px;
					text-align: center;
				}
				
				.button {
					background-color: rgb(156, 160, 176);
					border: solid 2px #5c5f77;
					border-radius: 4px;
					padding: 4px;
					color: rgb(239, 241, 245);
					text-decoration: none;
					margin: 8px;
				}
				
				.text {
					color: #4c4f69;
					margin: 8px;
				}
				
				.link {
					color: rgb(30, 102, 245);
					text-decoration: underline
				}
				
				.footer {
					text-align: center;
				}
			""".trimIndent()
		}
	}
	body {
		header {
			h1 { + "Hollybike" }
		}
		div(classes = "card") {
			p(classes = "text") {
				+ "Vous avez été invité à rejoindre l'association $association sur hollybike"
			}
			p(classes = "text") {
				+ "Voici le lien de connexion"
			}
			a(link, classes = "button") {
				+ "Se connecter"
			}
		}
		footer(classes = "footer") {
			p(classes = "link") {
				+ link
			}
		}
	}
}