# Tiny Bash Desktop Calculator

This is a little desktop calculator. Written in bash. Run it by
running `./calc` or test it by running `./test`.

The point of this little experiment was to play with a fun development
workflow I read about
[here](https://medium.com/@kentbeck_7670/limbo-on-the-cheap-e4cfae840330)
and
[here](https://medium.com/@kentbeck_7670/test-commit-revert-870bbd756864),
and then extrapolated on to suit my own outside-in London-style TDD
habits. Which leads to...

## to add a feature

Follow these steps:

1. Set the environment variable `GDS_TASK` to a short string describing the feature.
1. Add an integration test that describes the feature, but keep it
   pended (don't begin the function name with `T_` just yet)
1. Run `./test-and-commit`
1. See the tests pass, and your pended integration test get committed
1. Un-pend your integration test
1. Run `./test-and-commit`
1. See the integration test fail (and magically pend itself)
1. Do
   1. Write a pended unit test that will get you part way to your feature
   1. Run `./test-and-commit`
   1. See the unit test fail (and magically pend itself)
   1. Write some code to make the unit test pass
   1. Run `./test-and-commit`
   1. Either
	  - See the test pass and commit -- good job!
	  - See the test fail and revert -- try again.
   1. Loop until your feature is implemented
1. Unpend your integration test
1. Run `./test-and-commit`
1. See the test pass, and commit.
1. `git push`

I haven't expermented properly with `./limbo` since I've been soloing,
but it was part of Kent Beck's original intent in the posts above so
I've included a copy.

## Anything interesting about the code?

...well, there's a tiny tiny expression parser written in bash, which
seems to kinda work. And since bash doesn't have extensible in-memory
data structures, I'm using the file system to build my abstract syntax
tree.
