package com.nicos.examplechannelnativeandroidwithcomplexdata

import android.widget.Toast
import com.nicos.examplechannelnativeandroidwithcomplexdata.data.NativeDataModel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL_NAME = "complex_data_channel_name"
        private const val METHOD_NAME = "complex_data"
    }

    private var nativeDataModel = NativeDataModel();

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        MethodChannel(messenger, CHANNEL_NAME).setMethodCallHandler { call, result ->
            if (call.method.toString() == METHOD_NAME) {
                parseDataFromFlutter(call.arguments.toString(), result)
            }
        }
    }

    private fun parseDataFromFlutter(arguments: String, result: MethodChannel.Result) {
        JSONObject(arguments).apply {
            //parse the data from Flutter and save it into native data model
            nativeDataModel.id = this.optInt("id")
            nativeDataModel.text = this.optString("text")
            nativeDataModel.subText = this.optString("sub_text")

            Toast.makeText(
                this@MainActivity,
                "Current data from Flutter -> id: ${nativeDataModel.id} text: ${nativeDataModel.text} subText: ${nativeDataModel.subText}",
                Toast.LENGTH_SHORT
            ).show()

            updateTheValuesAndSendingBackToFlutter(result = result)
        }
    }

    private fun updateTheValuesAndSendingBackToFlutter(result: MethodChannel.Result) {
        //updating the value - lets say request an api and get the new data
        nativeDataModel.apply {
            id = (2..15).random()
            text = "updated text"
            subText = "updated subText"
        }

        Toast.makeText(
            this@MainActivity,
            "Updated data from Flutter -> id: ${nativeDataModel.id} text: ${nativeDataModel.text} subText: ${nativeDataModel.subText}",
            Toast.LENGTH_SHORT
        ).show()

        JSONObject().apply {
            this.put("id", nativeDataModel.id)
            this.put("text", nativeDataModel.text)
            this.put("sub_text", nativeDataModel.subText)

            result.success(this.toString())
        }
    }
}
