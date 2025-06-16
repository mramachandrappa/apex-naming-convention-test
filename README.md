🧪 Apex Class Naming Convention Check – GitHub PR Validation
As part of our quality enforcement, Apex classes in the classes/ folder must follow a defined naming convention. This is automatically checked when you raise a pull request.

✅ Supported File Name Patterns
Your Apex class file name must match the regular expression pattern defined by the repository variable REGEX_PATTERN.

Current Regex Pattern (example):
^[A-Z]{3,5}_{1,2}[a-zA-Z0-9]+\.((cls)|(cls-meta|trigger-meta\.xml))$

✅ Examples that PASS
File Name	Why it passes
ABC_MyClass.cls	3 uppercase letters + 1 underscore + name + .cls
XYZ__MyTrigger.cls	3 uppercase letters + 2 underscores + name + .cls
QWE__Logic.cls-meta.xml	Ends with .cls-meta.xml
DEF_Some.cls-meta.xml	Ends with .cls-meta.xml

❌ File Names That Will Fail
File Name	Why it fails
abc_Test.cls	Starts with lowercase letters
ABCDE___Test.cls	More than 2 underscores
XYZ-MyClass.cls	Uses - instead of _
XYZ_MyClass.txt	Invalid extension .txt
XYZ123_MyClass.cls	Prefix contains numbers

📝 PR Comment Summary
When a pull request is raised by adding files in the classes/ folder:

A bot comment will appear like this:

markdown
Copy
Edit
**Apex Class Naming Convention Check**
- Result        : Passed!
- Invalid Files : None!
- Message       : Thanks for following naming convention check!

markdown
Copy
Edit
**Apex Class Naming Convention Check**
- Result        : Failed!
- Invalid Files : XYZ__Wrong.cls, ABC_invalid-class.cls
- Message       : Kindly update classes as per naming convention defined.
📌 Notes for Contributors
The regex pattern is centrally defined using a repository variable: REGEX_PATTERN

PR checks apply only when new files are added in classes/.

This is enforced on main, feature/**, and env/** branches.

Violating the naming convention will cause the PR check to fail.

