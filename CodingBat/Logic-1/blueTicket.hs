{-From https://codingbat.com/prob/p192267
You have a blue lottery ticket, with ints a, b, and c on it. This makes three pairs,
which we'll call ab, bc, and ac. Consider the sum of the numbers in each pair. If any
pair sums to exactly 10, the result is 10. Otherwise if the ab sum is exactly 10 more
than either bc or ac sums, the result is 5. Otherwise the result is 0.
-}
import Test.Hspec


blueTicket :: Int -> Int -> Int -> Int
blueTicket a b c = undefined

main :: IO ()
main = hspec $ describe "Tests:" $ do
   it "10" $ blueTicket 9 1 0 `shouldBe` 10
   it "0" $ blueTicket 9 2 0 `shouldBe` 0
   it "10" $ blueTicket 6 1 4 `shouldBe` 10

