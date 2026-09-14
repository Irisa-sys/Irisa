@ApplicationModule(
        id = "game.archive",
        allowedDependencies = {
                "game :: runtime",
                "llm :: generation",
                "llm :: embedding",
                "indexing :: materials",
                "indexing :: search"
        }
)
package com.irisa.game.archive;

import org.springframework.modulith.ApplicationModule;
