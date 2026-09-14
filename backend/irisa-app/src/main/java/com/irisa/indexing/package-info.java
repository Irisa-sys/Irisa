@ApplicationModule(
        id = "indexing",
        allowedDependencies = {
                "game.court :: event",
                "game.polarizer :: event",
                "llm :: embedding"
        }
)
package com.irisa.indexing;

import org.springframework.modulith.ApplicationModule;
