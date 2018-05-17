module Cup where


-- Construct, which construct object with message receiving power

cup fl0z = \message -> message fl0z


-- Create cup object

coffeeCup = cup 10


-- Emulate attr_reader
getOz aCup = aCup (\flOz -> flOz)

-- Something like setter. Actually it's just a method which changes object state.
drink aCup ozDrunk = cup (flOz - ozDrunk)
  where flOz = getOz aCup
