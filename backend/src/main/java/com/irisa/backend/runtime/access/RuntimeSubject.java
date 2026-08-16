package com.irisa.backend.runtime.access;

import java.util.Objects;

/** Trusted subject projected from the authenticated platform principal. */
public final class RuntimeSubject {

    private final String userId;
    private final SubjectType type;

    public RuntimeSubject(String userId, SubjectType type) {
        this.userId = Objects.requireNonNull(userId, "userId");
        this.type = Objects.requireNonNull(type, "type");
    }

    public String getUserId() {
        return userId;
    }

    public SubjectType getType() {
        return type;
    }

    public enum SubjectType {
        USER,
        GUEST
    }
}
