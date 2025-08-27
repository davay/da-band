# Quirks

You may be wondering why relationships to other models are marked optional.

It's so that we can easily update views when child models are updated.

See: https://stackoverflow.com/questions/78831554/swiftdata-mode-does-not-update-the-view-when-i-insert-child-records

Otherwise, we have to do predicate magic, which also in certain pages cause the app to hang forever, and I can't figure out why

Sample of old code:

```swift
// since configuration is passed in as a parameter, its value doesn't update after adding a gesture
// hence this predicate that filters out appropriate gestures
@Query private var gestures: [Gesture]
init(configuration: Configuration) {
    self.configuration = configuration
    // fixes "cannot convert value of type 'PredicateExpressions.Equal<...> to closure result type 'any StandardPredicateExpression<Bool>'"
    // this is because Predicate is a macro (transformed at compile time), and it has limitations
    let configurationID = configuration.id
    // behind a swiftui property wrapper, theres an underscore version that manages the underlying wrapper object
    // @Query property means its holding a Query object, a @State property holds a State object, and so on
    _gestures = Query(filter: #Predicate<Gesture> { gesture in
        gesture.configuration.id == configurationID
    }, sort: \Gesture.createdAt, order: .reverse)
}
```
