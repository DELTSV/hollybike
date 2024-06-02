package hollybike.api.utils

import hollybike.api.html.linkMail
import kotlinx.html.html
import kotlinx.html.stream.appendHTML
import org.simplejavamail.api.mailer.config.TransportStrategy
import org.simplejavamail.email.EmailBuilder
import org.simplejavamail.mailer.MailerBuilder
import java.util.concurrent.CompletableFuture

class MailSender(
	smtpUrl: String,
	smtpPort: Int,
	smtpUsername: String,
	smtpPassword: String,
	private val sender: String
) {
	private val mailer = MailerBuilder
		.withSMTPServerHost(smtpUrl)
		.withSMTPServerPort(smtpPort)
		.withSMTPServerUsername(smtpUsername)
		.withSMTPServerPassword(smtpPassword)
		.withTransportStrategy(TransportStrategy.SMTP_TLS)
		.withDebugLogging(true)
		.buildMailer()

	fun linkMail(link: String, dest: String, association: String): CompletableFuture<Void> {
		EmailBuilder.startingBlank()
			.from(sender)
			.to(dest)
			.withSubject("Lien d'inscription a hollybike")
			.withHTMLText(StringBuilder().appendHTML().html {
				linkMail(link, association)
			}.toString())
			.buildEmail()
			.let {
				return mailer.sendMail(it)
			}
	}

}
