# Code Quality

## Spotbugs (https://spotbugs.github.io/)

*(Standard spotbugs profile with [excludes](spotbugs/exclude.xml))*

Verify via `spotbugs`:

```
mvn --fail-at-end -DskipTests -P spotbugs clean verify
```

```
mvn --fail-at-end -DskipTests -P spotbugs \ 
        -Dspotbugs-maven-plugin.failOnError=false \
                clean verify site site:stage
```

## PMD (https://pmd.github.io/)

*([Custom pmd](pmd/ruleset.xml) profile with 
[exclude-pmd](pmd/exclude-pmd.properties) and [exclude-cpd](pmd/exclude-cpd.properties))*

Verify via `pmd`:

```
mvn --fail-at-end -DskipTests -P pmd clean verify
```

```
mvn --fail-at-end -DskipTests -P pmd \
        -Dmaven-pmd-plugin.failOnViolation=false \
                clean verify site site:stage
```

## Checkstyle (https://checkstyle.sourceforge.io/)

* *([Custom common checkstyle](checkstyle/common-rules.xml) profile with 
[common-suppressions](checkstyle/common-suppressions.xml) for all classes)*

Verify via `checkstyle`:

```
mvn --fail-at-end -DskipTests -P checkstyle clean verify
```

```
mvn --fail-at-end -DskipTests -P checkstyle \
        -Dmaven-checkstyle-plugin.failOnViolation=false \
                clean verify site site:stage
```

### All tools

Verify via `spotbugs`, `pmd`, `checkstyle`:

```
mvn --fail-at-end -DskipTests -P spotbugs,pmd,checkstyle clean verify
```

```
mvn --fail-at-end -DskipTests -P spotbugs,pmd,checkstyle \
        -Dspotbugs-maven-plugin.failOnError=false \
        -Dmaven-pmd-plugin.failOnViolation=false \
        -Dmaven-checkstyle-plugin.failOnViolation=false \
                clean verify site site:stage
```
