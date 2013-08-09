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

    https://dss-dw.dev/terms - index of all terms/quarters

    https://dss-dw.dev/courses - index of all courses

    https://dss-dw.dev/courses/[term-code] - index of all courses for that term code

    https://dss-dw.dev/departments - index of all ous (departments but not personally made groups)

    https://dss-dw.dev/departments/history - information about the history department

    https://dss-dw.dev/departments/history/people - information about the history department's current people (maybe included in the above query, depends on size/performance)

    https://dss-dw.dev/departments/history/courses - information about the history department's current courses (maybe included in the above query, depends on size/performance

    https://dss-dw.dev/departments/history/courses/[term-code] - information about the history department's courses for term 'term-code'

    https://dss-dw.dev/people - index of all people

    https://dss-dw.dev/people?q=thi - index of all people with names containing 'thi'

    https://dss-dw.dev/people/cthielen.json - information about user with Kerberos ID 'cthielen'

## Reporting Bugs, Issues
Use the issue tracker found at [GitHub](https://github.com/cthielen/dss-dw/issues).

### Known Issues
There's currently a 'conflict' in Oracle's Instant Client and many gems which use LDAP code ('pg', 'mysql2') -- Oracle's code relies on a redefinition of some LDAP-'standard' symbols like ldap_first_entry, which can lead to linking errors. This codebase avoids LDAP for this reason and recommends if you have segmentation faults or assertion errors while using Oracle code, you link against a version of your library ('pg' or 'mysql2', for example) which does not have LDAP support compiled in. Be aware that you can compile a special gem and package it in vendor/cache/ if you need LDAP support in these gems system-wide.
