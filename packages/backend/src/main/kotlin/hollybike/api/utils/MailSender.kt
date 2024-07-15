package hollybike.api.utils

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

	fun linkMail(link: String, dest: String, association: String, senderName: String): CompletableFuture<Void> {
		EmailBuilder.startingBlank()
			.from(sender)
			.to(dest)
			.withSubject("Lien d'inscription a hollybike")
			.withHTMLText(htmlInvitation(link, association, senderName))
			.buildEmail()
			.let {
				return mailer.sendMail(it)
			}
	}

	fun passwordMail(link: String, username: String, dest: String): CompletableFuture<Void> {
		EmailBuilder.startingBlank()
			.from(sender)
			.to(dest)
			.withSubject("Demande de changement de mot de passe")
			.withHTMLText(htmlChange(link, username))
			.buildEmail()
			.let {
				return mailer.sendMail(it)
			}
	}

	private fun htmlInvitation(link: String, association: String, senderName: String): String =
		this::class.java.getResource("/mail/invitation.html")?.readText()
			?.replace("{{SENDER_NAME}}", senderName)
			?.replace("{{ASSOCIATION}}", association)
			?.replace("{{LINK}}", link)
			?: ""

	private fun htmlChange(link: String, username: String): String =
		this::class.java.getResource("/mail/changepassword.html")?.readText()
			?.replace("{{USERNAME}}", username)
			?.replace("{{LINK}}", link)
			?: ""

}
