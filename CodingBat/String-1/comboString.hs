{-From https://codingbat.com/prob/p168564
Given 2 strings, a and b, return a string of the form short+long+short, with the shorter
string on the outside and the longer string on the inside. The strings will not be the
same length, but they may be empty (length 0).
-}
import Test.Hspec


comboString :: String -> String -> String
comboString a b = undefined

main :: IO ()
main = hspec $ describe "Tests:" $ do
   it "\"hiHellohi\"" $ comboString "Hello" "hi" `shouldBe` "hiHellohi"
   it "\"hiHellohi\"" $ comboString "hi" "Hello" `shouldBe` "hiHellohi"
   it "\"baaab\"" $ comboString "aaa" "b" `shouldBe` "baaab"

