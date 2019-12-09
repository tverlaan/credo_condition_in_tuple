# Credo ConditionInTuple

A simple [Credo](https://github.com/rrrene/credo) check that will not allow you to write
conditions inside tuples.

## Explanation

Having a condition in a tuple makes your code harder to follow. You have to scan the text inside
the tuple to see where the comma is and where the closing curly brace is. By avoiding this it is
more clear to the reader what the data looks like.
