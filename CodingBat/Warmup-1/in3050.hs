{-From https://codingbat.com/prob/p132134
Given 2 int values, return true if they are both in the range 30..40 inclusive, or they
are both in the range 40..50 inclusive.
-}
import Control.Exception (assert)


in3050 :: Int -> Int -> Boolean
in3050 a b = undefined

main = do
    assert (in3050 30 31 == true) (putStrLn "Test passed")
    assert (in3050 30 41 == false) (putStrLn "Test passed")
    assert (in3050 40 50 == true) (putStrLn "Test passed")
    assert (in3050 30 31 == true) (putStrLn "Test passed")
    assert (in3050 30 41 == false) (putStrLn "Test passed")
    assert (in3050 40 50 == true) (putStrLn "Test passed")
