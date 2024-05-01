package hollybike.api

import com.trendyol.stove.testing.e2e.http.http
import com.trendyol.stove.testing.e2e.system.TestSystem.Companion.validate
import hollybike.api.types.user.TUser
import io.kotest.core.spec.style.FunSpec
import io.kotest.matchers.shouldBe
import io.ktor.http.*

class Users : FunSpec({
	test("Should get current user") {
		validate {
			http {
				getResponse<TUser>(
					"/api/users/me",
					token = tokenStore.get("l.vandenbossche@gmail.com"),
					expect = { actual ->
						actual.status shouldBe HttpStatusCode.OK.value
					}
				)
			}
		}
	}
})