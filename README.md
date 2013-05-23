tssearch
========

The terasaur search backend is Apache Solr.  This repository contains the Solr schema
and configuration files, dependencies (via Ivy), and Ant tasks for jumpstarting
the project.

## Building ##

    ant build

## Running ##

The project is designed to run in a tomcat or jetty container.  However, it may be helpful
to execute Solr in a local console.  There's an ant task to make it easy.

    ant run

