package hollybike.api.html

import kotlinx.html.*

fun HTML.linkMail(link: String, association: String) {
	body {
		header {
			h1 { text("Hollybike") }
		}
		main {
			p {
				text("Vous avez été invité à rejoindre l'association $association sur hollybike")
			}
			p {
				text("Voici le lien de connexion")
			}
			a(link) {
				text("Se connecter")
			}
		}
		footer {
			p {
				text(link)
			}
		}
	}
}