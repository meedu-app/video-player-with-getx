package app.meedu.m_player;

import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        BinaryMessenger messenger = flutterEngine.getDartExecutor().getBinaryMessenger();
        MethodChannel channel = new MethodChannel(messenger, "app.meedu/m_player");
        channel.setMethodCallHandler((call, result) -> {
            if (call.method.equals("pip")) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    this.pipOn(result);
                }
            }
        });

    }


    @RequiresApi(api = Build.VERSION_CODES.N)
    private void pipOn(MethodChannel.Result result) {
        getActivity().enterPictureInPictureMode();
        result.success(null);
    }
}
