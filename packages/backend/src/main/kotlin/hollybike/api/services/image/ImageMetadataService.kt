package hollybike.api.services.image

import hollybike.api.types.event.image.TImageMetadata
import kotlinx.datetime.Instant
import org.apache.commons.imaging.Imaging
import org.apache.commons.imaging.bytesource.ByteSource
import org.apache.commons.imaging.common.RationalNumber
import org.apache.commons.imaging.formats.jpeg.JpegImageMetadata
import org.apache.commons.imaging.formats.jpeg.exif.ExifRewriter
import org.apache.commons.imaging.formats.tiff.constants.GpsTagConstants
import org.apache.commons.imaging.formats.tiff.constants.TiffTagConstants
import org.apache.commons.imaging.formats.tiff.taginfos.TagInfo
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.IOException
import java.text.SimpleDateFormat

class ImageMetadataService {
	private fun getValueFromCoordinates(data: ByteArray, tag: TagInfo, refTag: TagInfo): Double? {
		return try {
			val metadata = Imaging.getMetadata(data)

			if (metadata is JpegImageMetadata) {
				val gpsInfo = metadata.findExifValueWithExactMatch(tag) ?: return null

				val gpsValue = gpsInfo.value as Array<RationalNumber>
				val gpsRef = metadata.findExifValueWithExactMatch(refTag) ?: return null
				val value = gpsValue[0].toDouble() + gpsValue[1].toDouble() / 60 + gpsValue[2].toDouble() / 3600

				return if (gpsRef.value == "S" || gpsRef.value == "W") -value else value
			}
			null
		} catch (e: IOException) {
			e.printStackTrace()
			null
		}
	}

	private fun getLatitudeFromExif(data: ByteArray): Double? {
		return getValueFromCoordinates(
			data,
			GpsTagConstants.GPS_TAG_GPS_LATITUDE,
			GpsTagConstants.GPS_TAG_GPS_LATITUDE_REF
		)
	}

	private fun getLongitudeFromExif(data: ByteArray): Double? {
		return getValueFromCoordinates(
			data,
			GpsTagConstants.GPS_TAG_GPS_LONGITUDE,
			GpsTagConstants.GPS_TAG_GPS_LONGITUDE_REF
		)
	}

	private fun getAltitudeFromExif(data: ByteArray): Double? {
		return try {
			val metadata = Imaging.getMetadata(data) ?: return null

			if (metadata is JpegImageMetadata) {
				val gpsInfo = metadata.findExifValueWithExactMatch(GpsTagConstants.GPS_TAG_GPS_ALTITUDE) ?: return null
				val gpsValue = gpsInfo.value as RationalNumber

				return gpsValue.toDouble()
			}
			null
		} catch (e: IOException) {
			e.printStackTrace()
			null
		}
	}

	private fun getTakenTimeFromExif(data: ByteArray): Instant? {
		return try {
			val metadata = Imaging.getMetadata(data) ?: return null

			if (metadata is JpegImageMetadata) {
				val gpsInfo = metadata.findExifValue(TiffTagConstants.TIFF_TAG_DATE_TIME) ?: return null

				val gpsValue = gpsInfo.value as String
				val test = SimpleDateFormat("yyyy:MM:dd HH:mm:ss").parse(gpsValue)

				return Instant.fromEpochMilliseconds(test.time)
			}
			null
		} catch (e: IOException) {
			e.printStackTrace()
			null
		}
	}

	fun removeExifData(inputData: ByteArray): ByteArray {
		try {
			val inputStream = ByteArrayInputStream(inputData)
			val byteSource = ByteSource.inputStream(inputStream, null)

			val outputStream = ByteArrayOutputStream()

			val exifRewriter = ExifRewriter()
			exifRewriter.removeExifMetadata(byteSource, outputStream)

			return outputStream.toByteArray()
		} catch (e: Exception) {
			e.printStackTrace()
			println("Failed to remove EXIF data: ${e.message}")
			return inputData
		}
	}

	fun getImageMetadata(data: ByteArray): TImageMetadata {
		val latitude = getLatitudeFromExif(data)
		val longitude = getLongitudeFromExif(data)
		val altitude = getAltitudeFromExif(data)
		val takenTime = getTakenTimeFromExif(data)

		val position = if (latitude != null && longitude != null) {
			TImageMetadata.Position(
				latitude = latitude,
				longitude = longitude,
				altitude = altitude
			)
		} else null

		return TImageMetadata(
			position = position,
			takenDateTime = takenTime,
		)
	}
}