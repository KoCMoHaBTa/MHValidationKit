# MHValidationKit

[![Build Status](https://www.bitrise.io/app/c427c2fae8969cc4.svg?token=pWWJ60wd984FUy8sK7Skqw&branch=master)](https://www.bitrise.io/app/c427c2fae8969cc4)

This library was created to solve the struggle of input form validations and styling. I've created it in order to help me resolve shitty validation infrastructure in one of the projects i've been working on, but i never had a chance to use it, since i created it. It will probably be my first attempt to resolve this problem when i encounter it again, however there are some design flaws that must be resolved first, that i discovered in attempt to use it at first place.  

I will leave most of it undocumented until i mange to finalize it and believe that it is ready for the public.

In case you are curiosu - feel free to take a look and experiment with it.

There are unit tests that will help you understand how it works.

### The case:
We have an input form, mostly will be table view with text fields.
Any rows can be validated and custom styling should be able to be applied.

The idea was to create an infrastructure which could allow the developers to just:

- write simple validators
- mark validatable and styleble views
- connect validators with validatable views

### Design flaws:
- validators should optionally be able to be stylable per type
- when composing validators - whic style should be applied?
- we should be able to perfom validation without applyting styling
