package com.example.util;

import java.io.FileInputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

// Đọc file .env ở root project (không cần thêm thư viện dotenv)
// Không hardcode: mọi giá trị bắt buộc phải nằm trong .env hoặc env thật
public class EnvConfig {
    private static final Map<String, String> MAP = new HashMap<>();

    static {
        String[] candidates = {".env", "../.env", "../../.env"};
        for (String c : candidates) {
            try {
                Path p = Paths.get(System.getProperty("user.dir"), c).normalize();
                if (Files.exists(p)) { load(p.toString()); break; }
            } catch (Exception ignored) {}
        }
        try {
            var url = EnvConfig.class.getClassLoader().getResource(".env");
            if (url != null) load(Paths.get(url.toURI()).toString());
        } catch (Exception ignored) {}
    }

    private static void load(String file) {
        try (FileInputStream fis = new FileInputStream(file)) {
            String content = new String(fis.readAllBytes());
            for (String line : content.split("\\R")) {
                line = line.trim();
                if (line.isEmpty() || line.startsWith("#")) continue;
                int eq = line.indexOf('=');
                if (eq < 0) continue;
                String k = line.substring(0, eq).trim();
                String v = line.substring(eq + 1).trim();
                if ((v.startsWith("\"") && v.endsWith("\"")) || (v.startsWith("'") && v.endsWith("'"))) {
                    v = v.substring(1, v.length() - 1);
                }
                MAP.putIfAbsent(k, v);
            }
        } catch (Exception ignored) {}
    }

    // Bắt buộc: thiếu là throw ngay, không dùng giá trị ngầm
    public static String getRequired(String key) {
        String env = System.getenv(key);
        if (env != null && !env.isBlank()) return env;
        String v = MAP.get(key);
        if (v == null || v.isBlank()) {
            throw new IllegalStateException(
                "Missing config '" + key + "'. Copy .env.example -> .env và điền giá trị.");
        }
        return v;
    }

    // Tùy chọn: có default rõ ràng do caller truyền vào, không hardcode trong class này
    public static String get(String key, String def) {
        String env = System.getenv(key);
        if (env != null && !env.isBlank()) return env;
        return MAP.getOrDefault(key, def);
    }
}
