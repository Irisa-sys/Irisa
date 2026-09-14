package com.irisa

import org.springframework.modulith.core.ApplicationModules
import spock.lang.Specification

class ModulithSpec extends Specification {

    def modules = ApplicationModules.of(IrisaApplication)

    def "modules honor allowed dependencies"() {
        expect:
        modules.verify()
    }

    def "only MVP modules exist"() {
        expect:
        modules.collect { it.identifier.toString() }.toSorted() == [
                "game",
                "game.archive",
                "game.court",
                "game.polarizer",
                "gateway",
                "identity",
                "indexing",
                "llm",
        ]
    }
}
