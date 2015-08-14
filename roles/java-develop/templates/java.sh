JAVA_HOME=/usr/lib/jvm/jdk-8-oracle-arm-vfp-hflt
export JAVA_HOME

MAVEN_HOME=/opt/apache-maven-{{ maven_version }}
export MAVEN_HOME

PATH="$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH"
export PATH
