package com.irisa.backend.common;

import java.util.UUID;

/** ID boundary used by modules until the ULID adapter is introduced. */
public final class ModuleId {

    private ModuleId() {
    }

    public static String newId() {
        return UUID.randomUUID().toString().replace("-", "");
    }
}
