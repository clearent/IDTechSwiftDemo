Try to build a pod containing our framework and the idtech framework.


# Release Notes

1.0.83 - Upgraded pod to use clearent framework release 1.0.26.3. This release has another fix for ios13. It is recommended you upgrade if you are using either audio jack readers or bluetooth readers (VP3300).

1.0.84 - Fixed an issue where the framework was not handling the card data correctly when the user has been presented with the 'USE MAGSTRIPE' message after an invalid insert. The result was an NSInvalidArgumentException being thrown.
