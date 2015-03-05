%%%
%%% Part I: Some basics
%%%

% Step 1: Create mem/2
%
% mem/2 will succeed if the first argument is a member of the second argument,
% assumed to be a list.  Ensure that this rule stops as soon as it determines
% that the element is in the list.
%


:- begin_tests(mem).

test(at_front) :- mem(a, [a, b, c]).
test(at_back) :- mem(c, [a, b, c]).
test(not_there) :- \+ mem(d, [a, b, c]).

:- end_tests(mem).

% Step 2: Create rev/2
%
% Now, create a rule that will succeed if the first argument is a list and the
% second argument is a list with the elements in reverse order.  Be sure to create
% an efficient implementation that will only take linear time.  You are not
% allowed to use append or any other rule except for those you may create for
% this step.
%
% Hint: you will need to use an accumulator
%


:- begin_tests(rev, [blocked('part 1, step 2')]).

test(empty_list) :- rev([], []).
test(one_element) :- rev([a], [a]).
test(two_elemnts) :- rev([a, b], [b, a]).
test(more_elemnts) :- rev([a, b, 1, [], foo(a)], [foo(a), [], 1, b, a]).

:- end_tests(rev).

% Step 3: Create len/2
%
% Create a rule len/2 that will succeed if the first argument is the length or
% number of elements in the second argument, a list.  Make sure all tests
% succeed without a warning.
%


:- begin_tests(len, [blocked('part 1, step 3')]).

test(empty_list) :- len(0, []).
test(one_element) :- len(1, [a]).
test(two_elements) :- len(2, [a, []]).
test(many_elements) :- len(5, [a, [], 3, baz(bar), [a]]).

:- end_tests(len).


%%%
%%% Part II: the maze
%%%
%
% In this next part, you will be writing a Prolog program that will be able to
% find the solution to the follwoing maze:
%
%   012345
% 0 ╗╞╦═╗╥
% 1 ╚╗╚╗╚╣
% 2 ╞╩═╝╞╩
%
% The entrance the maze is in cell(0,0) at the upper left and the exit is at
% cell(5,2).  The structure of this maze is codified using the follwoing rules:

corridor(cell(2,0), cell(2,1)).
corridor(cell(1,1), cell(1,2)).
corridor(cell(4,1), cell(4,0)).
corridor(cell(5,2), cell(5,1)).
corridor(cell(1,1), cell(0,1)).
corridor(cell(2,2), cell(3,2)).
corridor(cell(0,2), cell(1,2)).
corridor(cell(3,1), cell(2,1)).
corridor(cell(3,0), cell(2,0)).
corridor(cell(4,2), cell(5,2)).
corridor(cell(4,1), cell(5,1)).
corridor(cell(1,0), cell(2,0)).
corridor(cell(5,1), cell(5,0)).
corridor(cell(0,0), cell(0,1)).
corridor(cell(3,1), cell(3,2)).
corridor(cell(3,0), cell(4,0)).
corridor(cell(2,2), cell(1,2)).

% In these rules, each rule corridor(X,Y) states there is a corridor leading
% from room X to room Y.


% Step 1: Are two rooms connected?
%
% The corridor/2 rule only works one way.  Create a new rule connected/2 that
% will be true if there is a corridor between the two rooms (in any direction).
%



:- begin_tests(connected, [blocked('part 2, step 1')]).

% Tests that 2.0 connects to 2,1 and vice-versa
test(connected_forward) :- connected(cell(2,0), cell(2,1)), !.
test(connected_backward) :- connected(cell(2,1), cell(2,0)), !.

% Find all cells connected to/from 0,0
test(connected_from_0_0, all(X == [cell(0,1)])) :- connected(cell(0,0), X).
test(connected_to_0_0, all(X == [cell(0,1)])) :- connected(X, cell(0,0)).

% Find all cells connected to/from 1,3
test(connected_from_1_2, set(X == [cell(0,2), cell(1,1), cell(2,2)])) :- 
  connected(cell(1,2), X).
test(connected_to_1_2, set(X == [cell(0,2), cell(1,1), cell(2,2)])) :- 
  connected(X, cell(1,2)).

:- end_tests(connected).


% Step 2: path_to/3
%
% Now create path_to/3 which takes three arguments:
%  1. A start cell
%  2. An end cell
%  3. A path from the start cell to the end cell as a list.
%
%  Tips:
%    1. You will probably need to use an accumulator
%    2. It may be easier to construct the path in reverse and then reverse it
%    3. You can use negation to eliminate paths that backtrack on themselves
%
% Ensure that the tests pass with no warnings.
%



:- begin_tests(path_to, [blocked('part 2, step 2')]).

% verify that a path from a cell to itself consists of just the one cell
test(path_to_self) :-
  path_to(cell(0,0), cell(0,0), [cell(0,0)]).

% verify path going from 0,0 to 0,1
test(path_from_0_0_to_0_1) :-
  path_to(cell(0,0), cell(0,1), [cell(0,0), cell(0,1)]).

% verify path going from 0,1 to 0,0
test(path_from_0_1_to_0_0) :-
  path_to(cell(0,1), cell(0,0), [cell(0,1), cell(0,0)]).

% verify path going from 0,0 to 1,1
test(path_from_0_0_to_1_1) :-
  path_to(cell(0,0), cell(1,1), [cell(0,0), cell(0,1), cell(1,1)]).

% verify path going from 0,0 to 1,0
test(path_from_0_0_to_1_0) :-
  path_to(cell(0,0), cell(1,0),
  [cell(0,0), cell(0,1), cell(1,1), cell(1,2), cell(2,2), cell(3,2), cell(3,1),
  cell(2,1), cell(2,0), cell(1,0)]).

:- end_tests(path_to).


% Step 3: the solution
%
% Finally, you can put all of your work together by creating a rule
% maze_solution/4 that takes the following arguments:
%
%   1. the starting position
%   2. the ending position
%   3. the path from the start to the end
%   4. the length of the path
%
% Again, ensure that the test succeeds without any warnings.
%
% Once you have done this, you have succeeded in creating a non-trivial Prolog
% program that does something interesting.  Congratulations!
%


:- begin_tests(maze_solution, [blocked('part 2, step 3')]).

% find the solution, i.e. a path from  0,0 to 5,2
test(maze_solution) :-
  maze_solution(
    cell(0,0),
    cell(5,2),
    [cell(0,0), cell(0,1), cell(1,1), cell(1,2), cell(2,2), cell(3,2),
     cell(3,1), cell(2,1), cell(2,0), cell(3,0), cell(4,0), cell(4,1),
     cell(5,1), cell(5,2)],
    14).

:- end_tests(maze_solution).


