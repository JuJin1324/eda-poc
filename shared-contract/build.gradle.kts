plugins {
    `java-library`
}

java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(21))
    }
}

dependencies {
    api("com.fasterxml.jackson.core:jackson-annotations:2.19.0")
}
