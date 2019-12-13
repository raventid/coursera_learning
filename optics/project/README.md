# Lens rules


1. You get back what you set (set-get)

If you set using a lens, then view through it, you should get back what you just set!
```
view myLens (set myLens newValue structure)
  ==
newValue
```

2. Setting back what you got doesn’t do anything (get-set)

This law helps ensure that our lenses aren’t causing any weird side-effects like ticking a counter or mutating something other than their focus. If we set the focus to what that focus currently contains (according to view), then of course nothing should change!
```
set myLens (view myLens structure) structure
  ==
structure
```

3. Setting twice is the same as setting once (set-set)

This law is similar to the previous in that it ensures there’s no funny business happening behind the scenes. Setting through a lens is a declarative statement, and should be idempotent. If we set the focus twice, only the last set should have any visible effect.

```
set myLens differentValue (set myLens value structure)
  ==
set myLens differentValue structure
```
