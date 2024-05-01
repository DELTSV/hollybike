import com.google.devtools.ksp.processing.*
import com.google.devtools.ksp.symbol.KSAnnotated
import com.google.devtools.ksp.symbol.KSClassDeclaration

class Processor(
	val codeGenerator: CodeGenerator,
	val logger: KSPLogger
) : SymbolProcessor {
	override fun process(resolver: Resolver): List<KSAnnotated> {
		val symbols = resolver.getSymbolsWithAnnotation("kotlinx.serialization.Serializable", true).filter { it is KSClassDeclaration }
		val jsons = mutableListOf<String>()
		val sample = this::class.java.getResource("/reflect-config-sample.json")?.readText() ?: ""
		val outStream = try {
			if (symbols.toList().isEmpty()) {
				logger.warn("Empty @Serializable")
			}
			codeGenerator.createNewFileByPath(Dependencies(false, *resolver.getAllFiles().toList().toTypedArray()), "META-INF/native-image/reflect-config", "json")
		} catch (e: FileAlreadyExistsException) {
			logger.warn("Didn't create file")
			return symbols.toList()
		}
		symbols.toList().forEach { s ->
			if (s !is KSClassDeclaration) {
				return@forEach
			}
			val parameterTypes = if (s.typeParameters.isNotEmpty()) {
				s.typeParameters.joinToString(",", "[", "]") { _ -> "\"kotlinx.serialization.KSerializer\"" }
			} else {
				"[]"
			}
			val json = """
					{"name": "${s.qualifiedName?.asString()}","fields": [{"name": "Companion"}]},
					{"name": "${s.qualifiedName?.asString()}${'$'}Companion","methods":[{"name":"serializer","parameterTypes":$parameterTypes }]}
				""".trimIndent()
			jsons.add(json)
		}
		if (jsons.isNotEmpty()) {
			outStream.write("[$sample,${jsons.joinToString(",\n")}]".toByteArray())
		} else {
			logger.warn("No @Serializable")
			outStream.write("[$sample]".toByteArray())
		}
		return symbols.toList()
	}
}


class ProcessorProvider : SymbolProcessorProvider {
	override fun create(environment: SymbolProcessorEnvironment): SymbolProcessor {
		return Processor(environment.codeGenerator, environment.logger)
	}
}