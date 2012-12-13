{-# LANGUAGE OverloadedStrings, ScopedTypeVariables #-}

module Fold (
    testFolds) where

import Common

testFolds :: TestEnv -> Test
testFolds TestEnv{..} = TestCase $ do
  execute_ conn "CREATE TABLE testf (id INTEGER PRIMARY KEY, t INT)"
  execute_ conn "INSERT INTO testf (t) VALUES (4)"
  execute_ conn "INSERT INTO testf (t) VALUES (5)"
  execute_ conn "INSERT INTO testf (t) VALUES (6)"
  val <- fold_ conn "SELECT id,t FROM testf" ([],[]) sumValues
  assertEqual "fold1" ([3,2,1], [6,5,4]) val
  where
    sumValues (accId, accT) (id_ :: Int, t :: Int) = return $ (id_ : accId, t : accT)
