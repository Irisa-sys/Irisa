@ApplicationModule(
        id = "gateway",
        allowedDependencies = {
                "identity :: auth",
                "game :: runtime",
                "game.court :: command",
                "game.polarizer :: command",
                "game.archive :: command"
        }
)
package com.irisa.gateway;

import org.springframework.modulith.ApplicationModule;
