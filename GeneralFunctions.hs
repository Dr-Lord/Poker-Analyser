---- General Functions
--
--      Author:
--          Dr-Lord
--
--      Version:
--          1.0 - 09-10/06/2015
--
--      Description:
--          This package contains general functions which can be useful in many
--          different situations.
--
--   Sections:
--       0 - Imports
--       1 - Mathematical Functions
--       2 - Sorting and Grouping Functions
--       3 - Set Related Functions
--



---- 0 - IMPORTS ---------------------------------------------------------------

module GeneralFunctions where

import Data.Function (on)



---- 1 - MATHEMATICAL FUNCTIONS ------------------------------------------------

    -- Classic mathematical function; safe Type management
choose :: Integral a => a -> a -> a
infixl 5 `choose`
n `choose` k = fromIntegral $ product [sk+1..sn] `div` product [1..sn-sk]
    where [sn,sk] = map fromIntegral [n,k]


    -- Classic mathematical function; variable Integral Type; be careful
chooseUnsafe :: Integral a => a -> a -> a
infixl 5 `chooseUnsafe`
n `chooseUnsafe` k = product [k+1..n] `div` product [1..n-k]


    -- Return all the "choose" combinations of length k from a list of length n
    -- NOTE: This is a direct translation of the mathematical recurrence
    -- relation of Binomial Coefficients
    -- NOTE: (length $ combinations k xs) == ((length xs) `choose` k)
    -- NOTE: If using this function leads to a non-exhaustive condition error,
    --      the cause probably is a non-acceptable input (k>n, negative values, ...)
combinations :: Int -> [a] -> [[a]]
combinations k xs = combinations' (length xs) k xs
  where combinations' n k' ls@(y:ys)
          | k' == 0   = [[]]
          | k' >= n   = [ls]
          | null ls   = []
          | otherwise = map (y:) nkMinus1 ++ nMinus1
            where nkMinus1 = combinations' (n-1) (k'-1) ys
                  nMinus1  = combinations' (n-1)  k'    ys



---- 2 - SORTING AND GROUPING FUNCTIONS ----------------------------------------

    -- Descending and ascending list ordering function. Perfect for: sortBy XXX $ [[a]]
descLength, ascLength :: [a] -> [a] -> Ordering
descLength l1 l2 = (compare `on` length) l2 l1
ascLength  l1 l2 = (compare `on` length) l1 l2


    -- Stricter version of groupBy in the sense that does not assume that the
    -- provided comparison function is an equivalence relation.
    -- Only transitivity is assumed here
    -- i.e. This function compares adjacent values, and does not take the
    -- ("wrong") shortcut that the real groupBy does
groupBy' :: (a -> a -> Bool) -> [a] -> [[a]]
groupBy' _   []  = []
groupBy' _   [x] = [[x]]
groupBy' cmp (x:xs@(x':_))
    | cmp x x'   = (x:y):ys
    | otherwise  = [x]:r
        where r@(y:ys) = groupBy' cmp xs


    -- UnZip of lists of lists of any-(but fixed throughout)-length
    -- Eg: [[11,12,13,14],[21,22,23,24],[31,32,33,34]] ->
    --                          [[11,21,31],[12,22,32],[13,23,33],[14,24,34]]
    -- Notice: listUnZip . listUnZip == id
listUnZip :: [[a]] -> [[a]]
listUnZip []        = []
listUnZip xss@(h:_) = foldl separate (replicate (length h) []) xss
    where separate acc xs = zipWith (++) acc $ map (:[]) xs



---- 3 - SET RELATED FUNCTIONS -------------------------------------------------

    -- Check whether a set is a subset of a second set
subsetOf :: (Eq a) => [a] -> [a] -> Bool
a `subsetOf` b = all (`elem` b) a


