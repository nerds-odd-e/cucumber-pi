JAVA_HOME={{ java_home }}
export JAVA_HOME

MAVEN_HOME=/opt/apache-maven-{{ maven_version }}
export MAVEN_HOME

PATH="$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH"
export PATH
