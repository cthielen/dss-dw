# DSS Data Warehouse

## Introduction
**DSS Data Warehouse** (DSS DW) is a *shadowing and proxying service* for a number of data sources on the UC Davis campus. It is primarily designed to provide a RESTful HTTPS Basic Authenticated JSON interface to such data.

### Data Sources Compiled
DSS DW currently compiles information about **courses, people, and organizational units (OUs)** from the following data sources:

* Banner (courses)
* ldap.ucdavis.edu (people and OUs)
* IAM (people and OUs)

## API
The following are examples of the DSS Data Warehouse API:

    https://dss-dw.dev/api/terms - index of all terms/quarters
    
    https://dss-dw.dev/api/courses - index of all courses
    
    https://dss-dw.dev/api/departments - index of all departments
    
    https://dss-dw.dev/api/departments/[department-code] - information about a specific department
    
    #https://dss-dw.dev/api/departments/[department-code]/people - information about the department's current people
    
    https://dss-dw.dev/api/departments/[department-code]/courses - information about the department's current courses
    
    #https://dss-dw.dev/api/departments/[department-code]/terms/[term-code] - index of courses offered in term [term-code] for department [department-code]
    
    #https://dss-dw.dev/api/people - index of all people
    
    #https://dss-dw.dev/api/people?q=doe - index of all people with names containing 'doe' (case-insensitive)
    
    #https://dss-dw.dev/api/people/johndoe.json - information about user with Kerberos ID 'johndoe'

### API Versioning
API versioning is supported via URL:

    https://dss-dw.dev/api/terms - Query for terms using the latest API version
    https://dss-dw.dev/api/v0/terms - Query for terms using API v0
    https://dss-dw.dev/api/v1/terms - Query for terms using API v1
    ... etc.

## Reporting Bugs, Issues
Use the issue tracker found at [GitHub](https://github.com/cthielen/dss-dw/issues).

### Known Issues
(Deployment-related issue, not a concern for API consumers)
There's currently a 'conflict' in Oracle's Instant Client and many gems which use LDAP code ('pg', 'mysql2') -- Oracle's code relies on a redefinition of some LDAP-'standard' symbols like ldap_first_entry, which can lead to linking errors. This codebase avoids LDAP for this reason and recommends if you have segmentation faults or assertion errors while using Oracle code, you link against a version of your library ('pg' or 'mysql2', for example) which does not have LDAP support compiled in. Be aware that you can compile a special gem and package it in vendor/cache/ if you need LDAP support in these gems system-wide.
