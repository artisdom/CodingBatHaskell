{-From https://codingbat.com/prob/p103360
You and your date are trying to get a table at a restaurant. The parameter "you" is
the stylishness of your clothes, in the range 0..10, and "date" is the stylishness of
your date's clothes. The result getting the table is encoded as an int value with 0=no,
1=maybe, 2=yes. If either of you is very stylish, 8 or more, then the result is 2 (yes).
With the exception that if either of you has style of 2 or less, then the result is
0 (no). Otherwise the result is 1 (maybe).
-}
import Control.Exception (assert)


dateFashion :: Int -> Int -> Int
dateFashion you date = undefined

main = do
    assert (dateFashion 5 10 == 2) (putStrLn "Test passed")
    assert (dateFashion 5 2 == 0) (putStrLn "Test passed")
    assert (dateFashion 5 5 == 1) (putStrLn "Test passed")
    assert (dateFashion 5 10 == 2) (putStrLn "Test passed")
    assert (dateFashion 5 2 == 0) (putStrLn "Test passed")
    assert (dateFashion 5 5 == 1) (putStrLn "Test passed")
