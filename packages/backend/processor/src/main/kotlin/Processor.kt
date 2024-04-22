import com.google.devtools.ksp.processing.*
import com.google.devtools.ksp.symbol.KSAnnotated
import com.google.devtools.ksp.symbol.KSClassDeclaration

class Processor(
	val codeGenerator: CodeGenerator,
	val logger: KSPLogger
): SymbolProcessor {
	override fun process(resolver: Resolver): List<KSAnnotated> {
		logger.warn("RUN KSP")
		val symbols = resolver.getSymbolsWithAnnotation("kotlinx.serialization.Serializable", true)
		val jsons = mutableListOf<String>()
		val sample = this::class.java.getResource("/reflect-config-sample.json")?.readText()?: ""
		val outStream = try {
			codeGenerator.createNewFileByPath(Dependencies(false), "META-INF/native-image/reflect-config", "json")
		} catch (e: FileAlreadyExistsException) {
			return listOf()
		}
		return symbols.filter { it is KSClassDeclaration }.toList().also {
			it.forEach { s ->
				if(s !is KSClassDeclaration) {
					return@forEach
				}
				val parameterTypes = if((s as KSClassDeclaration).typeParameters.isNotEmpty()) {
					s.typeParameters.map { _ -> "\"kotlinx.serialization.KSerializer\""}.joinToString(",", "[", "]")
				} else {
					"[]"
				}
				val json = """
					{"name": "${s.qualifiedName?.asString()}","fields": [{"name": "Companion"}]},
					{"name": "${s.qualifiedName?.asString()}${'$'}Companion","methods":[{"name":"serializer","parameterTypes":$parameterTypes }]}
				""".trimIndent()
				jsons.add(json)
			}
			if(jsons.isNotEmpty()) {
				outStream.write("[$sample,${jsons.joinToString(",\n")}]".toByteArray())
			} else {
				outStream.write("[$sample]".toByteArray())
			}
		}
	}
}



class ProcessorProvider: SymbolProcessorProvider {
	override fun create(environment: SymbolProcessorEnvironment): SymbolProcessor {
		return Processor(environment.codeGenerator, environment.logger)
	}
}