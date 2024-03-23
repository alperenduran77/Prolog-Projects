% delivery_person(ID, Capacity, WorkHours, CurrentJob, CurrentLocation).
delivery_person('DP1', 10, 8, 'O1', 'Admin Office').
delivery_person('DP2', 15, 12, none, 'Library').
delivery_person('DP3', 20, 16, none, 'Engineering Bld.').

% object(ID, Weight, PickupPlace, DropOffPlace, Urgency, InTransitWith).
object('O1', 2, 'Admin Office', 'Institute Y', medium, 'DP1').
object('O2', 15, 'Library', 'Social Sciences Bld.', high, none).
object('O3', 6, 'Cafeteria', 'Lecture Hall A', low, none).
object('O4', 8, 'Institute X', 'Engineering Bld.', medium, none).
object('O5', 10, 'Social Sciences Bld.', 'Institute Y', high, none).

% route(Place1, Place2, Time).
route('Admin Office', 'Engineering Bld.', 3).
route('Engineering Bld.', 'Admin Office', 3).

route('Engineering Bld.', 'Lecture Hall A', 2).
route('Lecture Hall A', 'Engineering Bld.', 2).

route('Institute Y', 'Lecture Hall A', 3).
route('Lecture Hall A', 'Institute Y', 3).

route('Engineering Bld.', 'Library', 5).
route('Library', 'Engineering Bld.', 5).

route('Admin Office', 'Library', 1).
route('Library', 'Admin Office', 1).

route('Admin Office', 'Cafeteria', 4).
route('Cafeteria', 'Admin Office', 4).

route('Library', 'Cafeteria', 5).
route('Cafeteria', 'Library', 5).

route('Library', 'Institute Y', 3).
route('Institute Y', 'Library', 3).

route('Library', 'Social Sciences Bld.', 2).
route('Social Sciences Bld.', 'Library', 2).

route('Cafeteria', 'Social Sciences Bld.', 2).
route('Social Sciences Bld.', 'Cafeteria', 2).

route('Social Sciences Bld.', 'Institute X', 8).
route('Institute X', 'Social Sciences Bld.', 8).

route('Admin Office' , 'Admin Office', 0).
route('Engineering Bld.', 'Engineering Bld.', 0).
route('Institute Y', 'Institute Y', 0).
route('Library', 'Library', 0).
route('Lecture Hall A', 'Lecture Hall A', 0).
route('Cafeteria', 'Cafeteria', 0).
route('Social Sciences Bld.', 'Social Sciences Bld.', 0).
route('Institute X', 'Institute X', 0).


% Path finding predicate that avoids cycles.
shortest_path(A, B, Path, Length) :-
    travel(A, B, [A], Q, Len), 
    reverse(Q, Path),
    Length = Len.

% Recursive predicate to travel from A to B.
% It accumulates the path in Visited and the total length in Len.
travel(A, B, Visited, [B|Visited], L) :-
    route(A, B, L).
travel(A, B, Visited, Path, L) :-
    route(A, C, D),
    C \== B,
    \+member(C, Visited),
    travel(C, B, [C|Visited], Path, L1),
    L is D + L1.

% Find all shortest paths and their lengths from A to B.
all_shortest_paths(A, B, Paths) :-
    setof(L-Path, shortest_path(A, B, Path, L), Paths).

% Find the shortest of all shortest paths.
find_shortest_path(A, B, ShortestPath, Length) :-
    all_shortest_paths(A, B, [Length-ShortestPath|_]).

% Calculate the travel time between two places
travel_time(Place1, Place2, Time) :-
   find_shortest_path(Place1, Place2, _Path, Time).

% Helper predicate to format the list of available delivery persons.
modify_results([], []).  % Base case for recursion.
modify_results([(PersonID, Time)|Rest], [Formatted|FormattedRest]) :-
    format(atom(Formatted), 'Delivery person: ~w, Total Time: ~w', [PersonID, Time]),
    modify_results(Rest, FormattedRest).

% Check if a delivery person is available and can carry the object within their work hours
available_delivery_person(ObjectID, PersonID, Time) :-
    object(ObjectID, Weight, PickupPlace, DropOffPlace, _, none),
    delivery_person(PersonID, Capacity, WorkHours, none, CurrentLocation),
    Capacity >= Weight,
    travel_time(CurrentLocation, PickupPlace, TimeToPickup),
    travel_time(PickupPlace, DropOffPlace, TimeToDeliver),
    TotalTime is TimeToPickup + TimeToDeliver,
    TotalTime =< WorkHours,
    Time is TotalTime.

% If the object is already with a delivery person, return that person.
is_the_object_in_transit(ObjectID, DeliveryPersonID) :-
    object(ObjectID, _, _, _, _, DeliveryPersonID),
    DeliveryPersonID \= none.

% Updated check_delivery_stat1us predicate to format output and remove duplicates.
display_status(ObjectID, FormattedStatus) :-
    is_the_object_in_transit(ObjectID, DeliveryPersonID),
    !,  % Cut to prevent backtracking once a delivery person is found
    format(atom(FormattedStatus), 'Object in_transit_with (~w)', [DeliveryPersonID]).
display_status(ObjectID, FormattedStatus) :-
    setof((PersonID, Time), available_delivery_person(ObjectID, PersonID, Time), UniqueResults),
    modify_results(UniqueResults, FormattedUniqueResults),
    (   FormattedUniqueResults \= [] -> FormattedStatus = available_delivery_persons(FormattedUniqueResults)
    ;   FormattedStatus = no_available_delivery_persons
    ).

