{-From https://codingbat.com/prob/p110222
We'll say that a value is "everywhere" in an array if for every pair of adjacent elements
in the array, at least one of the pair is that value. Return true if the given value
is everywhere in the array.
-}
import Control.Exception (assert)


isEverywhere :: [Int] -> Int -> Boolean
isEverywhere nums val = undefined

main = do
    assert (isEverywhere [1,2,1,3] 1 == true) (putStrLn "Test passed")
    assert (isEverywhere [1,2,1,3] 2 == false) (putStrLn "Test passed")
    assert (isEverywhere [1,2,1,3,4] 1 == false) (putStrLn "Test passed")
    assert (isEverywhere [1,2,1,3] 1 == true) (putStrLn "Test passed")
    assert (isEverywhere [1,2,1,3] 2 == false) (putStrLn "Test passed")
    assert (isEverywhere [1,2,1,3,4] 1 == false) (putStrLn "Test passed")
