{-From https://codingbat.com/prob/p141494
Given a string and a second "word" string, we'll say that the word matches the string
if it appears at the front of the string, except its first char does not need to match
exactly. On a match, return the front of the string, or otherwise return the empty string.
So, so with the string "hippo" the word "hi" returns "hi" and "xip" returns "hip". The
word will be at least length 1.
-}
import Control.Exception (assert)


startWord :: String -> String -> String
startWord str word = undefined

main :: IO ()
main = do
    assert (startWord "hippo" "hi" == "hi") (putStrLn "Test passed")
    assert (startWord "hippo" "xip" == "hip") (putStrLn "Test passed")
    assert (startWord "hippo" "i" == "h") (putStrLn "Test passed")
    assert (startWord "hippo" "hi" == "hi") (putStrLn "Test passed")
    assert (startWord "hippo" "xip" == "hip") (putStrLn "Test passed")
    assert (startWord "hippo" "i" == "h") (putStrLn "Test passed")

