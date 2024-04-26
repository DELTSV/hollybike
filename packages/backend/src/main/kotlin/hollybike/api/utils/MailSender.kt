package hollybike.api.utils

import org.simplejavamail.api.mailer.config.TransportStrategy
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

}
