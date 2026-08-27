package com.irisa

import org.springframework.modulith.core.ApplicationModules
import spock.lang.Specification

class ModulithSpec extends Specification {

    def "modules honor allowed dependencies"() {
        expect:
        ApplicationModules.of(IrisaApplication).verify()
    }
}
