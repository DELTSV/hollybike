package hollybike.api.utils

import arrow.core.Option

class TokenStore {
	// map of email to token
	private val tokens = mutableMapOf<String, String>()

	fun store(email: String, token: String) {
		tokens[email] = token
	}

	fun get(email: String): Option<String> {
		return Option.fromNullable(tokens[email])
	}

	fun remove(email: String) {
		tokens.remove(email)
	}

	fun clear() {
		tokens.clear()
	}

	fun size(): Int {
		return tokens.size
	}
}