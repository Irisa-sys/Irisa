package com.irisa.backend.domain.psychology;

import com.irisa.backend.runtime.spi.DomainNode;
import org.springframework.stereotype.Component;

/** Domain registration placeholder; concrete workflow nodes are added in M6. */
@Component
public final class PsychologyDomainModule implements DomainNode {

    @Override
    public String nodeId() {
        return "psychology.placeholder";
    }
}
