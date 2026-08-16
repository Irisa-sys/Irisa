package com.irisa.backend.runtime.port.out;

/** Provider-neutral model invocation input assembled by the runtime. */
public final class ModelRequest {

    private final String executionId;
    private final String route;
    private final String prompt;

    public ModelRequest(String executionId, String route, String prompt) {
        this.executionId = executionId;
        this.route = route;
        this.prompt = prompt;
    }

    public String getExecutionId() {
        return executionId;
    }

    public String getRoute() {
        return route;
    }

    public String getPrompt() {
        return prompt;
    }
}
