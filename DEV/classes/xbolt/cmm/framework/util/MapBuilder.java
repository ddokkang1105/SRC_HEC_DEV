package xbolt.cmm.framework.util;

import java.util.HashMap;
import java.util.Map;

public class MapBuilder {
    private final Map<String, Object> map = new HashMap<>();

    public MapBuilder put(String key, Object value) {

        if (value != null) map.put(key, value);
        return this;
    }

    public Map<String, Object> build() {
        return map;
    }
}