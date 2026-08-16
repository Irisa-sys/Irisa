package com.irisa.backend.runtime.port.out;

/** Provider-neutral model invocation output returned to the runtime. */
public final class ModelResult {

    private final String text;
    private final long inputTokens;
    private final long outputTokens;

    public ModelResult(String text, long inputTokens, long outputTokens) {
        this.text = text;
        this.inputTokens = inputTokens;
        this.outputTokens = outputTokens;
    }

    public String getText() {
        return text;
    }

    public long getInputTokens() {
        return inputTokens;
    }

    public long getOutputTokens() {
        return outputTokens;
    }
}
