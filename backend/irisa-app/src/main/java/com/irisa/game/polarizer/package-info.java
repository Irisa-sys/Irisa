@ApplicationModule(
        id = "game.polarizer",
        allowedDependencies = {"game :: runtime", "llm :: generation"}
)
package com.irisa.game.polarizer;

import org.springframework.modulith.ApplicationModule;
