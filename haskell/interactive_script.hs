-- ghc interactive_script.hs -o i
-- echo "10 10 10" | ./i

main :: IO ()
main = interact ( (\finalOutput -> finalOutput ++ "\n") . show . sum . map read . words)
