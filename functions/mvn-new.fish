function mvn-new
    # Accepts:
    # - mvn-new <artifactId>
    # - mvn-new <groupId> <artifactId>
    #
    # If groupId is missing, default to "com.mycompany.app"

    set italics_start "\e[3m"
    set italics_end "\e[23m"

    if test (count $argv) -eq 0 -o (count $argv) -gt 2
        echo (set_color yellow)$italics_start"Usage:"$italics_end(set_color normal)
        echo (set_color yellow)$italics_start"  mvn-new <artifactId>"$italics_end(set_color normal)
        echo (set_color yellow)$italics_start"  mvn-new <groupId> <artifactId>"$italics_end(set_color normal)
        return 1
    end

    if test (count $argv) -eq 1
        set groupId "com.mycompany.app"
        set artifactId $argv[1]
    else
        set groupId $argv[1]
        set artifactId $argv[2]
    end

    if test -d $artifactId
        echo (set_color red)"The directory "(set_color --bold)"'$artifactId'"(set_color normal && set_color red)" already exists. Aborting."(set_color normal)
        return
    end

    echo (set_color  cyan)"Creating Maven project"(set_color --bold cyan)" $artifactId "(set_color normal && set_color cyan)"..."(set_color normal)

    mvn archetype:generate \
        -DgroupId=$groupId \
        -DartifactId=$artifactId \
        -Dpackage=$groupId \
        -DarchetypeArtifactId=maven-archetype-quickstart \
        -DarchetypeVersion=1.5 \
        -DinteractiveMode=false\

    set project_dir $artifactId

    # Rename App.java → Main.java
    mv $project_dir/src/main/java/(string replace --all . / $groupId)/App.java \
       $project_dir/src/main/java/(string replace --all . / $groupId)/Main.java

    # Replace class name inside file
    sed -i '' 's/class App/class Main/' \
        $project_dir/src/main/java/(string replace --all . / $groupId)/Main.java

    # Insert exec plugin in pom.xml
    set exec_plugin "
         <plugin>
           <groupId>org.codehaus.mojo</groupId>
           <artifactId>exec-maven-plugin</artifactId>
           <version>3.5.0</version>
           <configuration>
             <mainClass>$groupId.Main</mainClass>
           </configuration>
         </plugin>"

    echo (set_color cyan)"Adding exec-maven-plugin to pom.xml ..."(set_color normal)

    awk -v block="$(string escape $exec_plugin)" '
      /<\/plugins>/ {
         print block;
      }
      { print }
    ' $project_dir/pom.xml > $project_dir/pom_new.xml

    mv -f "$project_dir/pom_new.xml" "$project_dir/pom.xml"

    echo (set_color cyan)"Adding .gitignore ..."(set_color normal)

    set gitignore_content "# Maven build output
target/
pom.xml.tag
pom.xml.releaseBackup
pom.xml.versionsBackup
release.properties
dependency-reduced-pom.xml
buildNumber.properties
.mvn/timing.properties

# Eclipse
.project
.classpath
.settings/

# IntelliJ IDEA
.idea/
*.iml
*.iws
out/

# VSCode
.vscode/

# OS files
.DS_Store
Thumbs.db

# Logs
*.log

# Temporary files
*.tmp"

    echo $gitignore_content > $project_dir/.gitignore

    echo (set_color  green)"Done! Project created in "(set_color --bold green)"./$project_dir"(set_color normal)
end
