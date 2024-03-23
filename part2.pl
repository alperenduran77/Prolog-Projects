classify(SepalLength, SepalWidth, PetalLength, PetalWidth) :-
    (   PetalWidth =< 0.8
    ->  write('Iris-setosa')
    ;   PetalWidth > 0.8, PetalWidth =< 1.75
    ->  (   PetalLength =< 4.95
        ->  (   PetalWidth =< 1.65
            ->  write('Iris-versicolor')
            ;   write('Iris-virginica')
            )
        ;   PetalLength > 4.95
        ->  (   PetalWidth =< 1.55
            ->  write('Iris-virginica')
            ;   (   PetalLength =< 5.45
                ->  write('Iris-versicolor')
                ;   write('Iris-virginica')
                )
            )
        )
    ;   PetalWidth > 1.75
    ->  (   PetalLength =< 4.85
        ->  (   SepalWidth =< 3.10
            ->  write('Iris-virginica')
            ;   write('Iris-versicolor')
            )
        ;   write('Iris-virginica')
        )
    ).
