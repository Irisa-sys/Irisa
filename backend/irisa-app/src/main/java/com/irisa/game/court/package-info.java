@ApplicationModule(
        id = "game.court",
        allowedDependencies = {"game :: runtime", "llm :: generation"}
)
package com.irisa.game.court;

import org.springframework.modulith.ApplicationModule;
