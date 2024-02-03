# Unmanaged RAP Scenario

## Practicing with Brownfield Approach

Application code is already available to validate data, lock records, or persist data.
To be able to reuse existing code in the ABAP RESTful application programming model, it must have the following characteristics:
- It is modularized in function modules or methods
- Business logic hasn’t been mixed with technical aspects such as UI technologies or protocols
- The application code acts in its own transaction buffer
- No commits are made

![kép](https://github.com/attilaberencsi/abaprapunmanaged/assets/20442467/8f0bd1f0-ef14-4c07-8fdd-07534c8e3b6d)

Reference: https://www.sap-press.com/abap-restful-application-programming-model_5647/
