package com.irisa.backend.runtime.port.out;

/** Runtime-owned model port; implementations belong to agent.foundation. */
public interface ModelGatewayPort {

    ModelResult invoke(ModelRequest request);
}
