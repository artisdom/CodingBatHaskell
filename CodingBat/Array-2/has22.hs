{-From https://codingbat.com/prob/p121853
Given an array of ints, return true if the array contains a 2 next to a 2 somewhere.
-}
import Test.Hspec


has22 :: [Int] -> Bool
has22 nums = undefined

main :: IO ()
main = hspec $ describe "Tests:" $ do
   it "True" $ has22 [1,2,2] `shouldBe` True
   it "False" $ has22 [1,2,1,2] `shouldBe` False
   it "False" $ has22 [2,1,2] `shouldBe` False

