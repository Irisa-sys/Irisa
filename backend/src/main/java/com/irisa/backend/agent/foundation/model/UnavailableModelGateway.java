package com.irisa.backend.agent.foundation.model;

import com.irisa.backend.runtime.port.out.ModelGatewayPort;
import com.irisa.backend.runtime.port.out.ModelRequest;
import com.irisa.backend.runtime.port.out.ModelResult;
import org.springframework.stereotype.Component;

/** Startup-safe adapter placeholder; provider wiring is an M4 implementation task. */
@Component
public final class UnavailableModelGateway implements ModelGatewayPort {

    @Override
    public ModelResult invoke(ModelRequest request) {
        throw new IllegalStateException("No model provider is configured");
    }
}
