New Relic Puppet Module
=======================

A module to add New Relic to your nodes.

Platforms
---------

This module has been tested against the following target operating systems:

* Ubuntu 12.04 (32 & 64)

Requirements
------------

This module has no external dependencies.

Installation
------------

    puppet module install mwillbanks/newrelic

Usage
-----

    class { 'newrelic':
      license_key => 'YOUR_LICENSE_KEY',
      use_latest  => true
    }

Credits
-------

This module originated from the newrelic_server_monitor project.  Unfortunately
it did not work due to the nature of how it was built and was rebuilt due to
this.  More features may be added in the future depending on need.
