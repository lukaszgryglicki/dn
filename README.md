# n * k(d) repeated t times

Usage:
  ruby kn.rb T_trials N_casts Die_size

This Simulates T trials of casting N dies with D sides.
For example 1000 trials of casting 3 hexagonal (6 sides) dies.

1000 times:
3 * k(6).

When casting N sides die result is defined as:

Random number 1-N.
If result is 1 then return 3 - another d(n) cast.
If result is N then return (N - 2) + another d(n) cast.

Program generates final statistical analysis of all trials.

