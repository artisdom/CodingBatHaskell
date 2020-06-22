{-From https://codingbat.com/prob/p167430
Given an array of ints, return true if it contains a 2, 7, 1 pattern: a value, followed
by the value plus 5, followed by the value minus 1. Additionally the 271 counts even
if the "1" differs by 2 or less from the correct value.
-}
import Control.Exception (assert)


has271 :: [Int] -> Bool
has271 nums = undefined

main :: IO ()
main = do
    assert (has271 [1,2,7,1] == True) (putStrLn "Test passed")
    assert (has271 [1,2,8,1] == False) (putStrLn "Test passed")
    assert (has271 [2,7,1] == True) (putStrLn "Test passed")
    assert (has271 [1,2,7,1] == True) (putStrLn "Test passed")
    assert (has271 [1,2,8,1] == False) (putStrLn "Test passed")
    assert (has271 [2,7,1] == True) (putStrLn "Test passed")

