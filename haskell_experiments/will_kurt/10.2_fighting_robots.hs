module FightingRobots where

robot (name, attack, hp) = \message -> message (name, attack, hp)

killerRobot = robot("Killer", 20, 300)

giantRobot = robot("Giant", 4, 500)

-- Helper destructurers
name (n,_,_) = n
attack (_,a,_) = a
hp (_,_,h) = h

-- getters
getName self = self name
getAttack self = self attack
getHp self = self hp

-- setters
setName self newName = self (\(n, a, h) -> robot(newName, a, h))
setAttack self newAttack = self (\(n, a, h) -> robot(n, newAttack, h))
setHp self newHp = self (\(n, a, h) -> robot(n, a, newHp))

printRobot self = self (\(n, a, h) -> n ++ " attack:" ++ (show a) ++ " hp:" ++ (show h))

damage self attackDamage = self (\(n, a, h) -> robot (n, a, h - attackDamage))

fight self defender = damage defender attack
  where attack = if getHp self > 10
                 then getAttack self
                 else 0

giant1 = fight killerRobot giantRobot
killer1 = fight giant1 killerRobot
giant2 = fight killer1 giant1
killer2 = fight giant2 killer1
giant3 = fight killer2 giant2
killer3 = fight giant3 killer2


-- Not finished yet. It should stream (fight, flipped fight, fight, flipped fight)
fight3Rounds n firstRobot secondRobot = map (firstRobot secondRobot) $ map uncurry (rounds n)
  where rounds n = take n (cycle [fight])
