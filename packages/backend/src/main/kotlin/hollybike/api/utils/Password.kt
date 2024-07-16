/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.utils

import hollybike.api.exceptions.PasswordInvalid

fun String.validPassword(): Result<Unit> {
	if(this.length < 8) {
		return Result.failure(PasswordInvalid("Le mot de passe doit faire 8 caractère minimum"))
	}
	if(this.lowercase() == this) {
		return Result.failure(PasswordInvalid("Il manque une majuscule"))
	}
	if(this.uppercase() == this) {
		return Result.failure(PasswordInvalid("Il manque une minuscule"))
	}
	if(this.none { it.isDigit() }) {
		return Result.failure(PasswordInvalid("Il manque un chiffre"))
	}
	return Result.success(Unit)
}