package hollybike.api.utils

import org.simplejavamail.api.mailer.config.TransportStrategy
import org.simplejavamail.email.EmailBuilder
import org.simplejavamail.mailer.MailerBuilder

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

	fun sendLinkMail(to: String, from: String, host: String, link: String): Boolean {
		val html = this.javaClass.getResource("/mail/link.html")?.readText()
			?.replace("{{USERNAME}}", from)
			?.replace("{{DOMAIN}}", host)?.replace("{{LINK}}", link)
			?: return false
		val email = EmailBuilder.startingBlank()
			.withHTMLText(html)
			.withSubject("Invitation hollybike")
			.to(to)
			.from(sender)
			.buildEmail()
		mailer.sendMail(email)
		return true
	}
}
