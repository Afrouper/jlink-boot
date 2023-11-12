# Using JLink to create a custom and secure JVM

It is recommended not to use a plain JDK (or much better a JRE) at production stage. You get all the
stuff you did not need and also some critical vulnerabilities. As there are often CVEs in the desktop/client
parts of the JVM you can simple remove them.

This is a example how to create a custom JVM with jlink for a application build with maven. In this
sample we are using spring boot, but this does not matter and works also with Quarkus or plain Java
programs.

## Extend Maven
Extend Maven with a plugin to get a list or all maven java dependencies.
Use the `maven-dependency-plugin` in the build section:

```xml
<plugin>
    <artifactId>maven-dependency-plugin</artifactId>
    <version>3.6.1</version>
    <executions>
        <execution>
            <id>copy-dependencies</id>
            <phase>package</phase>
            <goals>
                <goal>copy-dependencies</goal>
            </goals>
            <configuration>
                <outputDirectory>${project.build.directory}/dependency</outputDirectory>
            </configuration>
        </execution>
    </executions>
</plugin>
```
This will copy all JARs in the given folder.

## Determine Java modules and create JVM
With the tool `jdeps` it is possible to create a list of Java modules which are needed from the
application:
```shell
jdeps --ignore-missing-deps -q --recursive --multi-release 17 --print-module-deps --class-path 'target/dependency/*' target/*.jar > target/deps.info
```

After getting a complete list of the used Java modules the tool `jlink` can create a custom JVM
containing only the needed Java modules:
```shell
jlink  --add-modules "$(cat target/deps.info)" --strip-debug --compress 2 --no-header-files --no-man-pages --output target/jvm
```

After this the JVM is placed in `target/jvm` and can be used.

> [!IMPORTANT]  
> The JVM is created for the system/architecture it is running for!

# Additional Hints
## Optimized build
The script `buildJvm.sh` contains all steps to create the custom JVM. It also uses the command
`strip` to shrink the size of the created libraries to address a [bug](https://github.com/docker-library/openjdk/issues/217)
in some jlink implementations which still exists.

## Docker multistage build
In `Dockerfile` is shown how to create a custom JVM in a multistage docker build
(this should worked in all environments) and use a very small [distroless](https://github.com/GoogleContainerTools/distroless)
image at runtime.
